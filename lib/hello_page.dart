import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dapp/contract_linking.dart';
import 'package:provider/provider.dart';

class HelloPage extends StatelessWidget {
  const HelloPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contractLink = Provider.of<ContractLinking>(context);
    final _messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter dApp'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: contractLink.isLoading
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Form(
                    child: Column(
                      children: [
                        Text(
                          'Welcome to Hello World dApp ${contractLink.deployedName}',
                        ),
                        TextFormField(
                          controller: _messageController,
                          decoration:
                              const InputDecoration(hintText: "Enter Message"),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CupertinoButton(
                          child: const Text('Set Message'),
                          onPressed: () {
                            contractLink.setMessage(_messageController.text);
                            _messageController.clear();
                          },
                        )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
