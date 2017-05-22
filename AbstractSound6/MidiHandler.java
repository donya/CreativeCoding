/*
 * MidiHandler for Processing
 * 
 * Support for simple note on/off functionality for 
 * a single MIDI output device.
 * 
 * Author: Donya Quick
 */

import javax.sound.midi.*; 
import java.util.*; // for lists of MIDI devices obtained by MidiUtils

class MidiHandler{
  MidiDevice outDev;
  int defaultVolume = 40;
  
  public void initialize() {
    initialize(0);
  }
    
  public void initialize(int outDevNum) { 
    try {
      List<MidiDevice> outDevs = MidiUtils.getOutputDevices();
      outDev = outDevs.get(outDevNum);
      System.out.println("Using device: "+outDev.getDeviceInfo().getName());
      outDev.open();
    } 
    catch (Exception e) {
      System.out.println(e.getMessage());
    }
  }
  
  public void noteOn(int pitchNumber) {
    noteOn(0, pitchNumber, defaultVolume);
  }
  
  public void noteOn(int channel, int pitchNumber, int volume) {
    MidiUtils.noteOn(outDev, channel, pitchNumber, volume);
  }
  
  public void noteOff(int pitchNumber) {
    noteOff(0, pitchNumber, 0);
  }
  
  public void noteOff(int channel, int pitchNumber, int volume) {
    MidiUtils.noteOff(outDev, channel, pitchNumber, volume);
  }
  
  public void programChange(int channel, int patchNum) {
    MidiUtils.programChange(outDev, channel, patchNum);
  }
  
  public void printOutputDeviceList() {
    MidiUtils.printDeviceInfo(MidiUtils.getOutputDeviceInfo()); // list all output devices
  }
}