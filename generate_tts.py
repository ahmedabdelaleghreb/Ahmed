"""generate_tts.py - template scripts to generate Egyptian Arabic TTS files for this project.
Usage notes:
- These are templates. You must install the provider SDK and set API keys.
- Example providers: Google Cloud Text-to-Speech, ElevenLabs, Amazon Polly.
- After generating audio files, place them into assets/audio/ar/ and update assets/data/*.json entries if filenames differ.
- This script contains two commented examples. Uncomment and configure the one you want to use.
"""
import os

def google_tts_example():
    # Requires: pip install google-cloud-texttospeech and GOOGLE_APPLICATION_CREDENTIALS env var pointing to service account json
    # from google.cloud import texttospeech
    # client = texttospeech.TextToSpeechClient()
    # synthesis_input = texttospeech.SynthesisInput(text="أسد")
    # voice = texttospeech.VoiceSelectionParams(language_code="ar-XA", name="ar-XA-Standard-A")  # example - check available voices
    # audio_config = texttospeech.AudioConfig(audio_encoding=texttospeech.AudioEncoding.LINEAR16)
    # response = client.synthesize_speech(input=synthesis_input, voice=voice, audio_config=audio_config)
    # with open('assets/audio/ar/alef_asad_eg.wav', 'wb') as out:
    #     out.write(response.audio_content)
    pass

def elevenlabs_example():
    # Requires: requests and ELEVENLABS_API_KEY env var
    # import requests, json, os
    # api_key = os.environ.get('ELEVENLABS_API_KEY')
    # url = 'https://api.elevenlabs.io/v1/text-to-speech/<VOICE_ID>'
    # headers = {'xi-api-key': api_key, 'Content-Type': 'application/json'}
    # payload = {'text': 'أسد', 'voice_settings': {'stability':0.7,'similarity_boost':0.75}}
    # r = requests.post(url, headers=headers, json=payload)
    # with open('assets/audio/ar/alef_asad_eg.wav', 'wb') as f:
    #     f.write(r.content)
    pass

if __name__ == '__main__':
    print('This is a template script. Edit with your provider credentials and uncomment an example to generate real TTS files.')