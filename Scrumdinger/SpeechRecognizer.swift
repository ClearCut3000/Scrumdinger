//
//  SpeechRecognizer.swift
//  Scrumdinger
//
//  Created by Николай Никитин on 17.01.2023.
//

import AVFoundation
import Foundation
import Speech
import SwiftUI

class SpeechRecognizer: ObservableObject {

  //MARK: - Properties
  /// enum for error handling
  enum RecognizerError: Error {
    case nilRecognizer
    case notAuthorizedToRecognize
    case notPermittedToRecord
    case recognizerIsUnavailable

    var message: String {
      switch self {
      case .nilRecognizer: return "Can't initialize speech recognizer"
      case .notAuthorizedToRecognize: return "Not authorized to recognize speech"
      case .notPermittedToRecord: return "Not permitted to record audio"
      case .recognizerIsUnavailable: return "Recognizer is unavailable"
      }
    }
  }

  /// transcription variable container
  var transcript: String = ""

  /// audio engine properties
  private var audioEngine: AVAudioEngine?
  private var request: SFSpeechAudioBufferRecognitionRequest?
  private var task: SFSpeechRecognitionTask?
  private let recognizer: SFSpeechRecognizer?

  //MARK: - Class Init/DeInit
  init() {
    recognizer = SFSpeechRecognizer()

    Task(priority: .background) {
      do {
        guard recognizer != nil else {
          throw RecognizerError.nilRecognizer
        }
        guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
          throw RecognizerError.notAuthorizedToRecognize
        }
        guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
          throw RecognizerError.notPermittedToRecord
        }
      } catch {
        speakError(error)
      }
    }
  }

  deinit {
    reset()
  }

  //MARK: - Methods
  /// transkription method, that returns
  func transcribe() {
    DispatchQueue(label: "Speech Recognizer Queue", qos: .background).async { [weak self] in
      guard let self = self, let recognizer = self.recognizer, recognizer.isAvailable else {
        self?.speakError(RecognizerError.recognizerIsUnavailable)
        return
      }

      do {
        let (audioEngine, request) = try Self.prepareEngine()
        self.audioEngine = audioEngine
        self.request = request
        self.task = recognizer.recognitionTask(with: request, resultHandler: self.recognitionHandler(result:error:))
      } catch {
        self.reset()
        self.speakError(error)
      }
    }
  }

  func stopTranscribing() {
    reset()
  }

  /// resets all audio engine, tasks and requests
  func reset() {
    task?.cancel()
    audioEngine?.stop()
    audioEngine = nil
    request = nil
    task = nil
  }

  private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
    let audioEngine = AVAudioEngine()

    let request = SFSpeechAudioBufferRecognitionRequest()
    request.shouldReportPartialResults = true

    let audioSession = AVAudioSession.sharedInstance()
    try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
    try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    let inputNode = audioEngine.inputNode

    let recordingFormat = inputNode.outputFormat(forBus: 0)
    inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
      request.append(buffer)
    }
    audioEngine.prepare()
    try audioEngine.start()

    return (audioEngine, request)
  }

  /// handle result of recognition process or error
  private func recognitionHandler(result: SFSpeechRecognitionResult?, error: Error?) {
    let receivedFinalResult = result?.isFinal ?? false
    let receivedError = error != nil

    if receivedFinalResult || receivedError {
      audioEngine?.stop()
      audioEngine?.inputNode.removeTap(onBus: 0)
    }

    if let result = result {
      speak(result.bestTranscription.formattedString)
    }
  }

  /// returns transcription to cllass property
  private func speak(_ message: String) {
    transcript = message
  }

  /// error handling method
  private func speakError(_ error: Error) {
    var errorMessage = ""
    if let error = error as? RecognizerError {
      errorMessage += error.message
    } else {
      errorMessage += error.localizedDescription
    }
    transcript = "<< \(errorMessage) >>"
  }
}

/// SpeechRecognizer authorization permission checker
extension SFSpeechRecognizer {
  static func hasAuthorizationToRecognize() async -> Bool {
    await withCheckedContinuation { continuation in
      requestAuthorization { status in
        continuation.resume(returning: status == .authorized)
      }
    }
  }
}

/// AudioSession rrecording authorization permission checker
extension AVAudioSession {
  func hasPermissionToRecord() async -> Bool {
    await withCheckedContinuation { continuation in
      requestRecordPermission { authorized in
        continuation.resume(returning: authorized)
      }
    }
  }
}
