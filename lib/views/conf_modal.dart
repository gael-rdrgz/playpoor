import 'package:flutter/material.dart';

class ConfModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 1 / 2,
      decoration: BoxDecoration(
        color: Color(0xfff2e4e9),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        spacing: 6,
        children: [
          SizedBox(height: 12),
          Text(
            "Configuración de audio",
            style: TextStyle(
              fontFamily: "DMSerif",
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.volume_down_rounded),
              ),
              Slider(value: 1.0, min: 0, max: 1.0, onChanged: (value) {}),
              IconButton(onPressed: () {}, icon: Icon(Icons.volume_up_rounded)),
            ],
          ),
          Text("Volumen"),
          Text(
            "Velocidad de reproducción",
            style: TextStyle(
              fontFamily: "DMSerif",
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: Text("0.5x"),
                selected: false,
                onSelected: (selected) {},
              ),
              ChoiceChip(
                label: Text("0.75x"),
                selected: false,
                onSelected: (selected) {},
              ),
              ChoiceChip(
                label: Text("1.0x"),
                selected: false,
                onSelected: (selected) {},
              ),
              ChoiceChip(
                label: Text("1.25x"),
                selected: false,
                onSelected: (selected) {},
              ),
              ChoiceChip(
                label: Text("1.5x"),
                selected: false,
                onSelected: (selected) {},
              ),
              ChoiceChip(
                label: Text("2.0x"),
                selected: false,
                onSelected: (selected) {},
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width * .8,
            decoration: BoxDecoration(
              color: Color(0xfff8f6f7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  "Información del audio",
                  style: TextStyle(
                    fontFamily: "DMSerif",
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          "Estado",
                          style: TextStyle(fontFamily: "DMSerif", fontSize: 14),
                        ),
                        Text(
                          "Pausado",
                          style: TextStyle(
                            fontFamily: "DMSerif",
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Duración",
                          style: TextStyle(fontFamily: "DMSerif", fontSize: 14),
                        ),
                        Text(
                          "00:00",
                          style: TextStyle(
                            fontFamily: "DMSerif",
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Posición",
                          style: TextStyle(fontFamily: "DMSerif", fontSize: 14),
                        ),
                        Text(
                          "00:00",
                          style: TextStyle(
                            fontFamily: "DMSerif",
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
