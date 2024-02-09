import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sorteador_ro/src/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController homeController = HomeController();

  late final TextEditingController initialTextEditingController =
      TextEditingController(
          text: homeController.initialNumber.value.toString());

  late final TextEditingController lastTextEditingController =
      TextEditingController(text: homeController.lastNumber.value.toString());

  //late bool canRepeatNumber = homeController.canRepeatNumber;

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sorteador RO'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Sortear um número de '),
                SizedBox(
                    width: 30,
                    child: TextFormField(
                      controller: initialTextEditingController,
                      onChanged: (value) {
                        if (value != '') {
                          homeController.initialNumber.value = int.parse(value);
                        }
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(3),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    )),
                const SizedBox(
                  width: 4,
                ),
                const Text('até'),
                const SizedBox(
                  width: 4,
                ),
                SizedBox(
                    width: 30,
                    child: TextFormField(
                      controller: lastTextEditingController,
                      onChanged: (value) {
                        if (value != '') {
                          homeController.lastNumber.value = int.parse(value);
                        }
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(3),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    )),
              ],
            ),
            Row(
              children: [
                ValueListenableBuilder(
                  valueListenable: homeController.cantRepeatNumber,
                  builder: (context, value, child) {
                    return Checkbox(
                      value: value,
                      onChanged: (v) {
                        homeController.clean();
                        homeController.cantRepeatNumber.value = v!;
                      },
                    );
                  },
                ),
                const Text('Não pode repetir o número')
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ValueListenableBuilder(
                    valueListenable: homeController.lastDrawedNumber,
                    builder: (context, value, child) {
                      if (value == null) {
                        return const Text('Faça o sorteio');
                      }
                      return Text(
                        value.toString(),
                        style: const TextStyle(fontSize: 64),
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            homeController.draw();
                            Future.delayed(
                              const Duration(milliseconds: 200),
                              () => scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 500),
                              ),
                            );
                          },
                          child: const Text('Sortear')),
                      ValueListenableBuilder(
                        valueListenable: homeController.allListDrawed,
                        builder: (context, value, child) {
                          if (value) {
                            return IconButton(
                                onPressed: () {
                                  homeController.clean();
                                },
                                icon: Icon(Icons.restart_alt));
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.25,
              child: Column(
                children: [
                  const Text('Histórico:'),
                  ValueListenableBuilder(
                    valueListenable: homeController.history,
                    builder: (context, value, child) {
                      return Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          reverse: true,
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(value[index].toString()),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
