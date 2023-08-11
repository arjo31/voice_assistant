import 'package:animate_do/animate_do.dart';
import 'package:chat_gpt/feature_box.dart';
import 'package:chat_gpt/openai_service.dart';
import 'package:chat_gpt/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();

  String lastWords = '';
  final OpenAIService openAIservice = OpenAIService();

  String? generatedContent;
  String? generatedImageURL;

  int start = 200;
  int end = 200;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          child: Text(
            'Arjo',
            style: TextStyle(
                color: Pallete.blackColor, fontWeight: FontWeight.w900),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            ZoomIn(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: const BoxDecoration(
                        color: Pallete.assistantCircleColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Container(
                    height: 123,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/image/virtualAssistant.png'))),
                  ),
                ],
              ),
            ),
            FadeInRight(
              child: Visibility(
                visible: generatedImageURL == null,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 40)
                      .copyWith(top: 30),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Pallete.borderColor,
                    ),
                    borderRadius: BorderRadius.circular(20)
                        .copyWith(topLeft: Radius.zero),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      generatedContent == null
                          ? 'Hello Arjo. What task can I do for you?'
                          : generatedContent!,
                      style: TextStyle(
                        fontFamily: 'Cera Pro',
                        fontSize: generatedContent == null ? 25 : 18,
                        color: Pallete.mainFontColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (generatedImageURL != null)
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Image.network(generatedImageURL!)),
              ),
            SlideInLeft(
              child: Visibility(
                visible: generatedContent == null && generatedImageURL == null,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 10, left: 22),
                  child: const Text(
                    'Here are a few features',
                    style: TextStyle(
                      fontFamily: 'Cera Pro',
                      color: Pallete.mainFontColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: generatedContent == null,
              child: Column(
                children: [
                  SlideInLeft(
                    duration: Duration(milliseconds: start),
                    child: const FeatureBox(
                      color: Pallete.firstSuggestionBoxColor,
                      headerText: 'ChatGPT',
                      infoText:
                          'A smarter way to stay organized and informed with ChatGPT',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + end),
                    child: const FeatureBox(
                        color: Pallete.secondSuggestionBoxColor,
                        headerText: 'Dall - E',
                        infoText:
                            'Get inspired and stay creative with your personal assistant powered by Dall - E'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + 2 * end),
                    child: const FeatureBox(
                        color: Pallete.thirdSuggestionBoxColor,
                        headerText: 'Smart Voice Assistant',
                        infoText:
                            'Get the best of both worlds with a voice assistant powered by ChatGPT and Dall-E'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: ZoomIn(
        delay: Duration(milliseconds: start + 3 * end),
        child: FloatingActionButton(
          onPressed: () async {
            if (speechToText.isNotListening &&
                await speechToText.hasPermission) {
              await startListening();
            } else if (speechToText.isListening) {
              final speech = await openAIservice.isArtPromptAPI(lastWords);
              if (speech.contains('https')) {
                generatedImageURL = speech;
                generatedContent = null;
                setState(() {});
              } else {
                generatedContent = speech;
                generatedImageURL = null;
                setState(() {});
                await systemSpeak(speech);
              }
              await systemSpeak(speech);
              await stopListening();
            } else {
              initSpeechToText();
            }
          },
          child: Icon(speechToText.isListening ? Icons.stop : Icons.mic),
          backgroundColor: Pallete.secondSuggestionBoxColor,
          tooltip: 'Tap to speak',
        ),
      ),
    );
  }
}
