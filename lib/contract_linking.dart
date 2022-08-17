import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class ContractLinking extends ChangeNotifier {
  final String _rpcUrl = "http://127.0.0.1:7545";
  final String _wsUrl = "ws://127.0.0.1:7545"; // web socket url
  final String _privateKey =
      "ffc2953fe6d93b7b72a94370274f188a6f6b7f21fdd02fff250c8ee194084626";

  Web3Client? _web3client; // helps in establishing in connection
  bool isLoading = true;

  String? _abiCode; // helps in reading the contract
  EthereumAddress?
      _contractAddress; // stores the address of the deployed smart contract

  Credentials? _credentials; //

  DeployedContract? _contract;
  ContractFunction? _message;
  ContractFunction? _setMessage;

  String? deployedName; // carries the name of the smart contract

  ContractLinking() {
    setup();
  }

  setup() async {
    // instantiating object of web3Client
    _web3client = Web3Client(
      _rpcUrl,
      Client(),
      socketConnector: () {
        return IOWebSocketChannel.connect(_wsUrl).cast<String>();
      },
    );

    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    String abiStringFile =
        await rootBundle.loadString('build/contracts/HelloWorld.json');
    final jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi['abi']);

    _contractAddress =
        EthereumAddress.fromHex(jsonAbi['networks']['5777']['address']);
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_privateKey);
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
      ContractAbi.fromJson(_abiCode!, "HelloWorld"),
      _contractAddress!,
    );

    _message = _contract!.function("message");
    _setMessage = _contract!.function("setMessage");
    getMessage();
  }

  getMessage() async {
    final _myMessage = await _web3client!
        .call(contract: _contract!, function: _message!, params: []);

    deployedName = _myMessage[0];
    isLoading = false;
    notifyListeners();
  }

  setMessage(String message) async {
    isLoading = true;
    notifyListeners();
    await _web3client!.sendTransaction(
      _credentials!,
      Transaction.callContract(
        contract: _contract!,
        function: _setMessage!,
        parameters: [message],
      ),
    );
    getMessage();
  }
}
