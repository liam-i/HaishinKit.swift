import AVFoundation
import Foundation
import Testing

@testable import HaishinKit

@Suite final class AudioMixerTrackTests {
    @Test func keep16000() {
        let format = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 16000, channels: 1, interleaved: true)!
        let track = AudioMixerTrack<AudioMixerTrackTests>(id: 0, outputFormat: format)
        track.delegate = self
        track.append(CMAudioSampleBufferFactory.makeSinWave(48000, numSamples: 1024, channels: 1)!)
        #expect(track.outputFormat.sampleRate == 16000)
        track.append(CMAudioSampleBufferFactory.makeSinWave(44100, numSamples: 1024, channels: 1)!)
        #expect(track.outputFormat.sampleRate == 16000)
    }

    @Test func keep44100() {
        let format = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 44100, channels: 1, interleaved: true)!
        let resampler = AudioMixerTrack<AudioMixerTrackTests>(id: 0, outputFormat: format)
        resampler.delegate = self
        resampler.append(CMAudioSampleBufferFactory.makeSinWave(48000, numSamples: 1024, channels: 1)!)
        #expect(resampler.outputFormat.sampleRate == 44100)
        resampler.append(CMAudioSampleBufferFactory.makeSinWave(44100, numSamples: 1024, channels: 1)!)
        #expect(resampler.outputFormat.sampleRate == 44100)
        resampler.append(CMAudioSampleBufferFactory.makeSinWave(44100, numSamples: 1024, channels: 1)!)
        #expect(resampler.outputFormat.sampleRate == 44100)
        resampler.append(CMAudioSampleBufferFactory.makeSinWave(16000, numSamples: 1024 * 20, channels: 1)!)
        #expect(resampler.outputFormat.sampleRate == 44100)
    }

    @Test func keep48000() {
        let format = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 48000, channels: 1, interleaved: true)!
        let track = AudioMixerTrack<AudioMixerTrackTests>(id: 0, outputFormat: format)
        track.delegate = self
        track.append(CMAudioSampleBufferFactory.makeSinWave(48000, numSamples: 1024, channels: 1)!)
        track.append(CMAudioSampleBufferFactory.makeSinWave(44100, numSamples: 1024 * 2, channels: 1)!)
    }

    @Test func passthrough48000_44100() {
        let format = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 44000, channels: 1, interleaved: true)!
        let resampler = AudioMixerTrack<AudioMixerTrackTests>(id: 0, outputFormat: format)
        resampler.delegate = self
        resampler.append(CMAudioSampleBufferFactory.makeSinWave(44000, numSamples: 1024, channels: 1)!)
        resampler.append(CMAudioSampleBufferFactory.makeSinWave(48000, numSamples: 1024, channels: 1)!)
    }

    @Test func passthrough16000_48000() {
        let format = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 48000, channels: 1, interleaved: true)!
        let track = AudioMixerTrack<AudioMixerTrackTests>(id: 0, outputFormat: format)
        track.delegate = self
        track.append(CMAudioSampleBufferFactory.makeSinWave(16000, numSamples: 1024, channels: 1)!)
        #expect(track.outputFormat.sampleRate == 48000)
        track.append(CMAudioSampleBufferFactory.makeSinWave(44100, numSamples: 1024, channels: 1)!)
    }
}

extension AudioMixerTrackTests: AudioMixerTrackDelegate {
    func track(_ track: HaishinKit.AudioMixerTrack<AudioMixerTrackTests>, didOutput audioPCMBuffer: AVAudioPCMBuffer, when: AVAudioTime) {
    }

    func track(_ track: HaishinKit.AudioMixerTrack<AudioMixerTrackTests>, errorOccurred error: HaishinKit.AudioMixerError) {
    }
}
