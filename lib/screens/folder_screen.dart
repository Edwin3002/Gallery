import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:gallery/language/language.dart';
import 'package:photo_manager/photo_manager.dart';
import '../widgets/asset_card.dart';

class FolderScreen extends StatefulWidget {
  final List<AssetEntity> assets;
  final String folderName;
  const FolderScreen({Key? key, required this.assets, required this.folderName})
      : super(key: key);

  @override
  State createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  int counterGrid = 4;
  double initialScaleCurrent = 0;
  double initialScaleCurrent2 = 0;
  int initialScale = 0;
  int initialScale2 = 0;

  final FlutterLocalization localization = FlutterLocalization.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folderName),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    isDismissible: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => _MediaView(
                        setCounterGrid: (value) {
                          counterGrid = value;
                          setState(() {});
                        },
                        counterGrid: counterGrid));
              },
              icon: const Icon(Icons.more_horiz_outlined)),
        ],
      ),
      body: GestureDetector(
        // onScaleUpdate: (details) {
        //   if (initialScale == 0) {
        //     initialScale = details.scale.toInt();
        //     return;
        //   }
        //   initialScale2 = details.scale.toInt();
        //   print(details.scale.toInt());
        //   if (initialScale == initialScale2) return;

        //   if (initialScale2 > 1.1) {
        //     final sum = counterGrid + (initialScale2 - initialScale);
        //     if (sum > 11 || sum < 1) return;
        //     counterGrid = sum;
        //   }
        //   setState(() {});
        //   initialScale = details.scale.toInt();
        //   return;
        // initialScaleCurrent = details.scale;
        // if (initialScaleCurrent < (initialScale - 0.1)) {
        //   // if (counterGrid > 9) return;
        //   print("siuuuuuuu");
        //   print(((details.scale - 1) * -10).toInt());
        //   final si = ((details.scale - 1) * -10).toInt();
        //   if (counterGrid == ((details.scale - 1) * -10).toInt()) return;
        //   counterGrid = initialScaleCurrent2 >= initialScaleCurrent
        //       ? counterGrid + ((details.scale - 1) * -10).toInt()
        //       : -((details.scale - 1) * -10).toInt();
        //   setState(() {});
        //   // initialScaleCurrent2 = details.scale;
        //   return;
        // } else if (initialScaleCurrent > (initialScale + 0.1)) {
        //   print(details.scale);
        //   print("noooooooooooo");
        //   // if (counterGrid == ((details.scale - 1) * 10).toInt()) return;
        //   // counterGrid = ((details.scale - 1) * 10).toInt();
        // }
        // int grid = (((initialScaleCurrent + details.scale) - 1) * 10).toInt();
        // double grid = (details.scale);
        // print("----------------> $grid");
        // // if (grid <= 1) return;
        // // if (grid >= 2) return;
        // if (details.scale >= initialScale) {
        // print("siuuuuuuu");
        //   // if (counterGrid <= 1) {
        //   counterGrid = counterGrid + ((grid + 0.5).toInt());
        // setState(() {});
        //   // }
        //   return;
        // } else {
        // print("noooooooooooo");
        //   // if (counterGrid <= 1) return;
        //   // print(counterGrid - ((1 - details.scale) * 10).toInt());
        //   counterGrid = counterGrid - ((details.scale - 1) * 10).toInt();
        //   setState(() {});
        // }
        // }
        // else if (initialScale < details.scale) {
        //   if (counterGrid == 2) return;
        //   counterGrid++;
        // }
        // Calcula el ángulo entre los dedos
        // Offset currentFocalPoint = details.focalPoint;
        // double dx = currentFocalPoint.dx - _startPosition1.dx;
        // double dy = currentFocalPoint.dy - _startPosition1.dy;
        // double angle = atan2(dy, dx) * (180 / pi); // Ángulo en grados
        // // print(currentFocalPoint);
        // // print(details.scale);
        // // Verificar si el gesto es diagonal
        // if (details.scale != 1.0) {
        //   // Ajuste para evitar movimientos no deseados
        //   if (angle.abs() > 30 && angle.abs() < 60) {
        //     // Ajusta los umbrales según sea necesario
        //     print("Diagonal Gesture");
        //   } else {
        //     print("Not Diagonal Gesture");
        //   }
        // }
        // },
        // onScaleEnd: (details) {
        //   initialScale == 0;
        //   initialScaleCurrent == 0;
        //   initialScaleCurrent2 == 0;
        //   setState(() {});
        // },
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: counterGrid,
          ),
          itemCount: widget.assets.length,
          itemBuilder: (_, index) {
            return AssetCard(
              asset: widget.assets[index],
            );
          },
        ),
      ),
    );
  }
}

class _MediaView extends StatefulWidget {
  final void Function(int) setCounterGrid;
  final int counterGrid;
  const  _MediaView({required this.setCounterGrid, required this.counterGrid});

  @override
  State<_MediaView> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<_MediaView> {
  double sliderValue = 4;
  final FlutterLocalization _localization = FlutterLocalization.instance;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.6,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      height: 5,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
                ListView(
                  controller: scrollController,
                  children: [
                    ListTile(
                      title: Text(
                        AppLocale.settings.getString(context),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      trailing: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close)),
                    ),
                    ListTile(
                        title: Row(
                          children: [
                            const Icon(Icons.view_week_outlined),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${AppLocale.columns.getString(context)} ${widget.counterGrid}",
                            ),
                          ],
                        ),
                        subtitle: Slider.adaptive(
                          value: sliderValue,
                          min: 2,
                          max: 6,
                          divisions: 4,
                          label: sliderValue.toInt().toString(),
                          onChanged: (value) {
                            sliderValue = value;
                            widget.setCounterGrid(value.toInt());
                            setState(() {});
                          },
                        )),
                    ListTile(
                      title: Row(
                        children: [
                          const Icon(Icons.translate),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(AppLocale.language.getString(context))
                        ],
                      ),
                      subtitle: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Radio(
                                value: "English",
                                groupValue: _localization.getLanguageName(),
                                onChanged: (value) {
                                  _localization.translate('en');
                                },
                              ),
                              const Text("English"),
                            ]),
                            Row(
                              children: [
                                Radio(
                                  value: "Español",
                                  groupValue: _localization.getLanguageName(),
                                  onChanged: (value) {
                                    _localization.translate('es');
                                  },
                                ),
                                const Text("Español"),
                                const SizedBox(
                                  width: 15,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
