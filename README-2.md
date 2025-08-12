Ahmed - تعليم الأطفال (مشروع جاهز للرفع على GitHub)
==================================================

محتوى الحزمة:
- مشروع Flutter مبسّط جاهز لتشغيله أو رفعه على GitHub.
- assets/content.json يحتوي على الحروف العربية، الأرقام، والحيوانات مع مسارات الصور والصوت.
- assets/image_map.csv يحتوي على روابط تحميل لصور حقيقية (Unsplash samples).
- scripts/download_images.sh لتحميل الصور إلى assets/images/ (حجم متوسط ~1024px).
- scripts/generate_tts_gtts.sh لتوليد ملفات mp3 بالعربية (gTTS).
- .github/workflows/build-apk.yml يبني APK غير موقّع ويضعه كـ artifact.
- assets/icon.png أيقونة قوس قزح بكلمة 'Ahmed'.

كيفية الاستخدام (سريع):
1) فك الضغط وادخل المجلد.
2) ارفع المجلد إلى مستودع GitHub جديد على حسابك (فرع main).
3) اذهب لصفحة Actions وشغّل workflow 'Build Unsigned APK' أو انتظر push.
4) بعد الانتهاء، نزّل artifact app-release-apk من صفحة run.
بديل محلي:
- لو تريد تعمل كل شيء محلياً: ثبت Flutter وPython، ثم شغّل:
  ./scripts/download_images.sh
  ./scripts/generate_tts_gtts.sh
  flutter pub get
  flutter build apk --release --no-shrink
  ستجد apk في build/app/outputs/flutter-apk/app-release.apk

ملاحظات:
- الصور والأصوات تم توليدها/تحميلها عبر سكربتات، ZIP الحالي يحتوي على المسارات وملفات سكربت، لكن قد لا يحتوي على جميع الصور والأصوات حتى تشغّل السكربت.
- gTTS يولد نطق بالعربية الفصحى (MSA). إذا تريد لهجة مصرية عالية الجودة نحتاج خدمة مدفوعة (مثل Azure TTS).

لو تحب أن أرفع لك نفس المشروع على GitHub (أحتاج صلاحية الوصول أو اسم المستخدم repo) أقدر أعمل ذلك خطوة بخطوة.
