import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:gallery/language/language.dart';
import 'package:gallery/widgets/folder_card.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<AssetEntity> assets = [];
  List<AssetPathEntity> paths = [];
  int counterGrid = 4;
  Future<void> _fetchAssets() async {
    paths = await PhotoManager.getAssetPathList();
    for (var element in paths) {
      final assetsPath = await element.getAssetListRange(start: 0, end: 1);
      assets.add(assetsPath[0]);
    }
    setState(() {});
  }

  @override
  void initState() {
    _fetchAssets();
    super.initState();
  }

  final FlutterLocalization localization = FlutterLocalization.instance;
  bool selectedFolders = false;
  List<String> numberFolders = [];
  int _selectedIndex = 0; // Keeps track of the selected index

  Future<void> deleteAllAssetsInPath(AssetPathEntity path) async {
    // Get all assets in the path
    final assets = await path.getAssetListRange(start: 0, end: 500000);

    // Delete each asset
    for (var asset in assets) {
      try {
        // Get the file from the asset
        final file = await asset.file;

        // Check if the file is not null and exists
        if (file != null && await file.exists()) {
          await file.delete();
          String? url = await asset.getMediaUrl();
          File(url!).delete();
        }
      } catch (e) {
        print('Failed to delete asset: $e');
      }
    }

    // Optionally remove the empty path from the media store
    // This step may require additional permissions or platform-specific code
    print('All assets in the path have been deleted.');
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
    switch (index) {
      case 0:
        print('Home tapped');
        // Navigate to home page or perform other actions
        break;
      case 1:
        for (var path in numberFolders) {
          final pathList = await PhotoManager.getAssetPathList(onlyAll: true);
          if (pathList.isNotEmpty) {
            // Delete all assets in the first available path
            await deleteAllAssetsInPath(pathList.first);
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('All assets deleted successfully')));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('No asset paths available')));
          }
        }
        // Navigate to search page or perform other actions
        break;
      case 2:
        print('Profile tapped');
        // Navigate to profile page or perform other actions
        break;
    }
  }

  void setSelectedFolders(bool value, String idFolder) {
    selectedFolders = value;
    if (value) {
      numberFolders.add(idFolder);
    } else {
      numberFolders.removeWhere((element) => element == idFolder);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: numberFolders.isEmpty
            ? Text(AppLocale.title.getString(context))
            : Text(
                "${AppLocale.selected.getString(context)} ${numberFolders.length}"),
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
      bottomNavigationBar: numberFolders.isNotEmpty
          ? BottomNavigationBar(
              currentIndex: _selectedIndex, // Set the current index
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.drive_file_move_outlined), label: "Move"),
                BottomNavigationBarItem(
                  icon: Icon(Icons.delete_outlined),
                  label: "Delete",
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.drive_file_rename_outline_outlined),
                    label: "Rename"),
              ],
              backgroundColor: Colors.indigo.shade800,
            )
          : const SizedBox.shrink(),
      body: GestureDetector(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: counterGrid,
          ),
          padding: const EdgeInsets.all(5),
          itemCount: assets.length,
          itemBuilder: (_, index) {
            return Padding(
              padding: const EdgeInsets.all(2),
              child: FolderCard(
                isSelectedFolders: numberFolders.isNotEmpty,
                setSelectedFolders: setSelectedFolders,
                path: paths[index],
                folder: paths[index],
              ),
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
  const _MediaView({required this.setCounterGrid, required this.counterGrid});

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
