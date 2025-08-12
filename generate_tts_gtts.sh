#!/usr/bin/env bash
set -e
# Requires: pip install gTTS==2.3.0
python3 - <<'PY'
import json, os
from gtts import gTTS
with open('assets/content.json','r',encoding='utf-8') as f:
    data = json.load(f)
os.makedirs('assets/audio/ar', exist_ok=True)
os.makedirs('assets/audio/animals', exist_ok=True)
for l in data.get('letters_ar',[]):
    text = l.get('word','')
    out = l.get('audio','assets/audio/ar/'+l.get('id')+'.mp3')
    if text:
        gTTS(text=text, lang='ar').save(out)
for n in data.get('numbers',[]):
    text = n.get('display','')
    out = n.get('audio','assets/audio/ar/'+n.get('id')+'.mp3')
    if text:
        gTTS(text=text, lang='ar').save(out)
for a in data.get('animals',[]):
    text = a.get('name_ar','')
    out = a.get('audio','assets/audio/animals/'+a.get('id')+'.mp3')
    if text:
        gTTS(text=text, lang='ar').save(out)
print('TTS generation complete')
PY
