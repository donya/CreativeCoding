import java.util.ArrayList; // for lists of MIDI devices
import java.util.List; // for lists of MIDI devices
import java.util.Vector; // for storing listeners
import javax.sound.midi.*;// for working with MIDI

/**
 * MidiUtils implementation for JavaOx
 * 
 * Functions for fetching device lists and device information.
 * 
 * @author Donya Quick
 */
public final class MidiUtils {
  
    // Constants for MIDI message decoding
    static final public int NOTE_ON = 144;
    static final public int NOTE_OFF = 144;
    static final public int PROGRAM_CHANGE = 192;
    static final public int PITCH_WHEEL = 224;
    static final public int MOD_WHEEL = 176;

    /*
    The following two global variables are meant to get rid of "garbage" 
    devices that are either Java-specific or that usually don't behave 
    properly. For example, the default MS synth on Windows produces two 
    entires: the MIDI mapper and the GS Wavetable synth, but only one should
    be used (usually the MIDI mapper).
    */
    static public boolean filterDevices = true; 
    static private String[] badDevs = new String[] {
        "Gervill",
        "Microsoft GS Wavetable Synth",
        "Real Time Sequencer",
    };
    
    static public boolean okDevName(String s) {
        boolean ok = true;
        if (filterDevices) {
            int i=0;
            while (ok && i<badDevs.length) {
                if (s.equals(badDevs[i])){
                    ok = false;
                }
                i++;
            }
        }
        return ok;
    }
    
    /**
     * Get information about all available MIDI input devices.
     * @return 
     */
    static public List<MidiDevice.Info> getInputDeviceInfo() {
        MidiDevice.Info[] allDevices = MidiSystem.getMidiDeviceInfo();
        List<MidiDevice.Info> inDevs = new ArrayList();
        for (int i = 0; i < allDevices.length; i++) {
            try {
                MidiDevice device = MidiSystem.getMidiDevice(allDevices[i]);
                // Does the device send MIDI messages?
                if (device.getMaxTransmitters() != 0) {
                    if (okDevName(allDevices[i].getName())) {
                        inDevs.add(allDevices[i]);
                    }
                }
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        }
        return inDevs;
    }
    
    /**
     * Get a list of all MIDI input devices.
     * @return 
     */
    static public List<MidiDevice> getInputDevices() {
        MidiDevice.Info[] allDevices = MidiSystem.getMidiDeviceInfo();
        List<MidiDevice> inDevs = new ArrayList();
        for (int i = 0; i < allDevices.length; i++) {
            try {
                MidiDevice device = MidiSystem.getMidiDevice(allDevices[i]);
                // Does the device send MIDI messages?
                if (device.getMaxTransmitters() != 0) {
                    if (okDevName(allDevices[i].getName())) {
                        inDevs.add(device);
                    }
                }
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        }
        return inDevs;
    }
    
    /**
     * Get information about all available MIDI output devices.
     * @return 
     */
    static public List<MidiDevice.Info> getOutputDeviceInfo() {
        MidiDevice.Info[] allDevices = MidiSystem.getMidiDeviceInfo();
        List<MidiDevice.Info> outDevs = new ArrayList();
        for (int i = 0; i < allDevices.length; i++) {
            try {
                MidiDevice device = MidiSystem.getMidiDevice(allDevices[i]);
                // Does the device receive MIDI messages?
                if (device.getMaxReceivers() != 0) {
                    if (okDevName(allDevices[i].getName())) {
                        outDevs.add(allDevices[i]);
                    }
                }
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        }
        return outDevs;
    }
    
    /**
     * Get all available MIDI output devices.
     * @return 
     */
    static public List<MidiDevice> getOutputDevices() {
        MidiDevice.Info[] allDevices = MidiSystem.getMidiDeviceInfo();
        List<MidiDevice> outDevs = new ArrayList();
        for (int i = 0; i < allDevices.length; i++) {
            try {
                MidiDevice device = MidiSystem.getMidiDevice(allDevices[i]);
                // Does the device Receive MIDI messages?
                if (device.getMaxReceivers() != 0) {
                    if (okDevName(allDevices[i].getName())) {
                        outDevs.add(device);
                    }
                }
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        }
        return outDevs;
    }
    
    /**
     * Fetches the names for a list of MidiDevices (from their Info)
     * @param devInfos list of device information (intended for use with 
     * getInputDeviceInfo() or getOutputDeviceInfo())
     * @return an array of device names as strings
     */
    static public String[] deviceNames(List<MidiDevice.Info> devInfos) {
        String[] s = new String[devInfos.size()];
        for (int i=0; i<s.length; i++) {
            s[i] = devInfos.get(i).getName();
        }
        return s;
    }
    
    /**
     * Print a list of MIDI device information.
     * @param devs List of devices information to print.
     */
    static public void printDeviceInfo(List<MidiDevice.Info> devs) {
        String[] s = deviceNames(devs);
        for (int i=0; i<s.length; i++) {
            System.out.println(s[i]);
        }
    }
    
    static public int[] decodeMessage(MidiMessage message) {
      byte[] data = message.getMessage();
      int s = -1;
      int c = -1;
      int d1 = -1;
      int d2 = -1;
      if (data.length >= 1) { // fetch type & channel
        int bitmask = 0b1111_0000;
        s = data[0] & bitmask;
        int bitmask2 = 0b0000_1111;
        c = data[0] & bitmask2;
      }
      if (data.length >=2) { // fetch data1 if it exists
        d1 = data[1];
      }
      if (data.length >=3) { // fetch data2 if it exists
        d2 = data[2];
      } 
      
      //println("s: "+s+", c: "+c+", d1: "+d1+", d2:"+d2);
      int[] intArray = new int[]{s,c,d1,d2};
      return intArray;
    }
    
    static public void sendMessage(MidiDevice outDev, MidiMessage message, long timestamp) {
      try {
        outDev.getReceiver().send(message,timestamp); 
      } catch (Exception e) {
        System.err.println(e.getMessage()); 
      }
    }
    
    static public void sendMessage(MidiDevice outDev, MidiMessage message) {
      sendMessage(outDev, message, -1);
    }
    
    static public void sendMessage(MidiDevice outDev, MidiMessage message, int timestamp) {
      sendMessage(outDev, message, (long)timestamp); 
    }
    
    static public void noteOn(MidiDevice outDev, int channel, int pitch, int volume, long timestamp) {
      try {
        ShortMessage shortMessage = new ShortMessage();
        shortMessage.setMessage(ShortMessage.NOTE_ON, channel, pitch, volume);
        sendMessage(outDev, shortMessage, timestamp);
      } catch (Exception e) {
        System.err.println(e.getMessage()); 
      }
    }
    
    static public void noteOn(MidiDevice outDev, int channel, int pitch, int volume) {
      noteOn(outDev, channel, pitch, volume, -1); 
    }
    
    static public void noteOff(MidiDevice outDev, int channel, int pitch, int volume, long timestamp) {
      try {
        ShortMessage shortMessage = new ShortMessage();
        shortMessage.setMessage(ShortMessage.NOTE_OFF, channel, pitch, volume);
        sendMessage(outDev, shortMessage, timestamp);
      } catch (Exception e) {
        System.err.println(e.getMessage()); 
      }
    }
    
    static public void noteOff(MidiDevice outDev, int channel, int pitch, long timestamp) {
      noteOff(outDev, channel, pitch, 0, timestamp);
    }
    
    static public void noteOff(MidiDevice outDev, int channel, int pitch) {
      noteOff(outDev, channel, pitch, 0, -1);
    }
    
    static public void noteOff(MidiDevice outDev, int channel, int pitch, int volume) {
      noteOff(outDev, channel, pitch, volume, -1); 
    }
}