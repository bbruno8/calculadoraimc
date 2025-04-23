import 'package:flutter/material.dart';

void main() {
  // Função principal que inicia o app e define o widget principal como Home()
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

// Widget com estado que representa a tela principal do app
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Controlador para o campo de peso, usado para acessar o texto digitado
  TextEditingController weightController = TextEditingController();

  // Controlador para o campo de altura
  TextEditingController heightController = TextEditingController();

  // Chave global para identificar e controlar o estado do formulário
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Texto que mostra o resultado do cálculo do IMC
  String infoText = "";

  // Cor do texto que mostra o resultado, muda conforme o IMC
  Color infoColor = Colors.black87;

  // Função que limpa os campos de entrada e o estado do formulário
  void resetFields() {
    setState(() {
      weightController.text = "";
      heightController.text = "";
      infoText = "";

      // remove o foco dos campos para forçar atualização assim evitando que os dados anteriores voltem para a tela
      FocusScope.of(context).unfocus();
    });
  }



  // Função que calcula o IMC e atualiza o texto e a cor baseados no resultado
  void calculete() {
    setState(() {
      // Converte os textos dos campos para double
      double weight = double.parse(weightController.text);
      double height =
          double.parse(heightController.text) / 100;
      double imc = weight / (height * height);

      // Verifica faixa do IMC e define texto e cor apropriados
      if (imc < 18.6) {
        infoText = "Abaixo do peso (${imc.toStringAsPrecision(4)})";
        infoColor = Colors.yellow;
      } else if (imc >= 18.6 && imc < 24.9) {
        infoText = "Peso ideal (${imc.toStringAsPrecision(4)})";
        infoColor = Colors.green;
      } else if (imc >= 24.9 && imc < 29.9) {
        infoText = "Levemente acima do peso (${imc.toStringAsPrecision(4)})";
        infoColor = Colors.orange;
      } else if (imc >= 29.9 && imc < 34.9) {
        infoText = "Obesidade Grau I (${imc.toStringAsPrecision(4)})";
        infoColor = Colors.deepOrange;
      } else if (imc >= 34.9 && imc < 39.9) {
        infoText = "Obesidade Grau II (${imc.toStringAsPrecision(4)})";
        infoColor = Colors.red;
      } else {
        infoText = "Obesidade Grau III (${imc.toStringAsPrecision(4)})";
        infoColor = Colors.purple;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Barra superior do app com título e botão de reset
        appBar: AppBar(
          title: Text("Calculadora de IMC"),
          backgroundColor: Colors.lightGreen,
          actions: [
            IconButton(onPressed: resetFields, icon: Icon(Icons.refresh))
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.person, size: 120, color: Colors.lightGreen),
                Center(
                  child: SizedBox(
                    width: 250,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Digite seu peso (kg)",
                        labelStyle: TextStyle(color: Colors.lightGreen),
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(color: Colors.black87, fontSize: 25),
                      controller: weightController,
                      // Validação para garantir que o campo não está vazio
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Insira seu peso";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: 250,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Digite sua altura (cm)",
                        labelStyle: TextStyle(color: Colors.lightGreen),
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(color: Colors.black87, fontSize: 25),
                      controller: heightController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Insira sua altura";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Center(
                  child: SizedBox(
                    width: 250,
                    // Botão que valida o formulário e chama a função de cálculo
                    child: TextButton(
                      onPressed: () {
                        final form = _formKey.currentState;
                        if (form != null && form.validate()) {
                          calculete();
                        }
                      },
                      child: Text("Calcular"),
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.black87,
                          backgroundColor: Colors.lightGreen,
                          fixedSize: const Size(25, 50),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          )),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(

                  infoText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    // pinta de acordo com o resultado do IMC
                    color: infoColor,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
