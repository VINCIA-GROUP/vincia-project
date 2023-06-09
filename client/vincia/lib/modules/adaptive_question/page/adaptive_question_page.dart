import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:uuid/uuid.dart';
import 'package:vincia/modules/adaptive_question/model/alternative_model.dart';
import 'package:vincia/modules/adaptive_question/page/controller/adaptive_question_controller.dart';
import 'package:vincia/modules/adaptive_question/page/controller/states/question_states.dart';
import 'package:vincia/shared/components/error_message_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class AdaptiveQuestionPage extends StatefulWidget {
  const AdaptiveQuestionPage({super.key});

  @override
  State<AdaptiveQuestionPage> createState() => _AdaptiveQuestionPageState();
}

class _AdaptiveQuestionPageState extends State<AdaptiveQuestionPage>
    with TickerProviderStateMixin {
  final _questionController = Modular.get<AdaptiveQuestionController>();

  late final AnimationController _chatButtonAnimationController;
  late final AnimationController _chatAnimationController;
  late final Future _initQuestion;
  List<types.Message> _messages = [];
  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );
  final _user1 = const types.User(
    id: '82091009-a484-4a89-ae75-a22bf8d6f3ac',
  );

  @override
  void initState() {
    final textMessage1 = types.TextMessage(
      author: _user1,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: "Hello",
    );
    _messages.add(textMessage1);
    super.initState();
    _initQuestion = _questionController.init();
    _chatButtonAnimationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _chatAnimationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 32,
          icon: const Icon(Icons.close),
          color: Colors.red,
          onPressed: () {
            Modular.to.pop("/home");
          },
        ),
        title: Center(
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        color: Theme.of(context).colorScheme.onBackground),
                    borderRadius: BorderRadius.circular(30)),
                padding:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                child: Observer(builder: (context) {
                  return Text(
                    _questionController.time,
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onBackground),
                  );
                }))),
        actions: [
          IconButton(
            iconSize: 32,
            onPressed: () {
              Modular.to.popAndPushNamed('/question');
            },
            color: Colors.green,
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
      body: Stack(
        children: [
          Observer(
            builder: (context) {
              var state = _questionController.state;
              var question = _questionController.question;
              if (state is FailureState) {
                ErrorMessageComponent.showAlertDialog(context,
                    state.failure.errors, () => {Modular.to.navigate("/home")});
              }
              if (question != null) {
                return ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    _equestionStatement(
                        context,
                        question.statement,
                        state is AnsweredQuestionState
                            ? state.isCorrect
                            : null),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          _questionController.question?.alternatives.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _alternatives(context, index,
                            _questionController.question!.alternatives[index]);
                      },
                    ),
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
          Observer(builder: (context) {
            if (_questionController.state is AnsweredQuestionState) {
              _chatButtonAnimationController.forward();
            }

            return Align(
              alignment: Alignment.bottomCenter,
              child: _chat(context),
            );
          }),
        ],
      ),
    );
  }

  Widget _chat(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: _chatButtonAnimationController,
        curve: Curves.fastOutSlowIn,
      ),
      axis: Axis.vertical,
      axisAlignment: -1,
      child: SizedBox(
        width: double.infinity,
        child: GestureDetector(
          onVerticalDragEnd: (details) {
            if (_chatAnimationController.isCompleted) {
              _chatAnimationController.reverse();
            } else {
              _chatAnimationController.forward();
            }
          },
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 15),
                      ]),
                  child: Icon(
                    _chatAnimationController.isCompleted
                        ? CupertinoIcons.chevron_down
                        : CupertinoIcons.chevron_up,
                    color: Theme.of(context).colorScheme.onSecondary,
                    size: 30,
                    fill: 0.9,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  height: 40,
                  alignment: Alignment.center,
                  child: Text(
                    "CHAT",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                ),
                SizeTransition(
                  sizeFactor: CurvedAnimation(
                    parent: _chatAnimationController,
                    curve: Curves.fastOutSlowIn,
                  ),
                  axis: Axis.vertical,
                  axisAlignment: -1,
                  child: Container(
                    height: constraints.maxHeight - 40 - 30,
                    color: Theme.of(context).colorScheme.secondary,
                    child: Chat(
                        theme: DefaultChatTheme(
                          inputBackgroundColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                        messages: _messages,
                        onSendPressed: _handleSendPressed,
                        showUserAvatars: true,
                        showUserNames: true,
                        user: _user),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _equestionStatement(
      BuildContext context, String statement, bool? isCorrect) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: isCorrect == null
                ? Theme.of(context).colorScheme.outline.withOpacity(0.5)
                : isCorrect
                    ? Colors.green.withOpacity(0.5)
                    : Colors.red.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 5,
          ),
        ],
      ),
      padding: const EdgeInsets.all(8.0),
      child: HtmlWidget(statement),
    );
  }

  Widget _alternatives(
      BuildContext context, int index, AlternativeModel alternative) {
    var letter = String.fromCharCode(index + 65);
    var buttonColor = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Observer(builder: (context) {
        if (_questionController.state is AnsweredQuestionState) {
          var state = _questionController.state as AnsweredQuestionState;
          if (state.alternativeId == alternative.id) {
            buttonColor = state.isCorrect ? Colors.green : Colors.red;
          }
        }
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
          onPressed: () => _questionController.answerQuestion(alternative.id),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(letter),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    alternative.text,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _initQuestion.ignore();
    _chatButtonAnimationController.dispose();
    _chatAnimationController.dispose();
    super.dispose();
  }
}
