//
//  HapticsManagerTests.swift
//  UnitopiaTests
//
//  Created by Justin Hold on 2/27/26.
//

import Testing
@testable import Unitopia

/// Tests for HapticsManager focus on calling prepare/play without crashing,
/// since haptic hardware is unavailable on simulator and the class guards against it.
@Suite("HapticsManager")
struct HapticsManagerTests {

    @Test("prepare() can be called without crashing on any device/simulator")
    func prepareDoesNotCrash() {
        let manager = HapticsManager()
        // Should be a no-op on simulator (no haptic hardware), no crash expected
        manager.prepare()
    }

    @Test("prepare() is idempotent — calling twice is safe")
    func prepareIsIdempotent() {
        let manager = HapticsManager()
        manager.prepare()
        manager.prepare()  // second call should be guarded by `engine == nil`
    }

    @Test("playResetPattern() can be called before prepare() without crashing")
    func playBeforePrepare() {
        let manager = HapticsManager()
        manager.playResetPattern()
    }

    @Test("playResetPattern() can be called after prepare() without crashing")
    func playAfterPrepare() {
        let manager = HapticsManager()
        manager.prepare()
        manager.playResetPattern()
    }

    @Test("playResetPattern() can be called multiple times without crashing")
    func playMultipleTimes() {
        let manager = HapticsManager()
        manager.prepare()
        manager.playResetPattern()
        manager.playResetPattern()
        manager.playResetPattern()
    }
}
