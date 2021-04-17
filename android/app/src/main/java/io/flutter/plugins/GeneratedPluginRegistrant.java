package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import com.dooboolab.fluttersound.FlutterSound;
import io.flutter.plugins.pathprovider.PathProviderPlugin;
import bz.rxla.flutter.speechrecognition.SpeechRecognitionPlugin;
import com.csdcorp.speech_to_text.SpeechToTextPlugin;
import com.tekartik.sqflite.SqflitePlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    FlutterSound.registerWith(registry.registrarFor("com.dooboolab.fluttersound.FlutterSound"));
    PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
    SpeechRecognitionPlugin.registerWith(registry.registrarFor("bz.rxla.flutter.speechrecognition.SpeechRecognitionPlugin"));
    SpeechToTextPlugin.registerWith(registry.registrarFor("com.csdcorp.speech_to_text.SpeechToTextPlugin"));
    SqflitePlugin.registerWith(registry.registrarFor("com.tekartik.sqflite.SqflitePlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
