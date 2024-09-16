import 'package:flutter/material.dart';
import 'package:gallery/screens/folder_screen.dart';
import 'package:photo_manager/photo_manager.dart';

class FolderCard extends StatefulWidget {
  const FolderCard({
    super.key,
    required this.path,
    required this.folder,
    required this.setSelectedFolders,
    required this.isSelectedFolders,
  });

  final AssetPathEntity path;
  final AssetPathEntity folder;
  final bool isSelectedFolders;
  final void Function(bool, String) setSelectedFolders;

  @override
  State<FolderCard> createState() => _AssetsFolderState();
}

class _AssetsFolderState extends State<FolderCard> {
  List<AssetEntity> assets = [];
  bool selected = false;
  Future<void> _fetchAssets() async {
    assets = await widget.path.getAssetListRange(start: 0, end: 50);
    setState(() {});
  }

  @override
  void initState() {
    _fetchAssets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return assets.isEmpty
        ? const SizedBox()
        : FutureBuilder(
            future: assets[0].thumbnailData.then((value) => value!),
            builder: (_, snapshot) {
              final bytes = snapshot.data;
              if (bytes == null) {
                return const Image(
                    image: AssetImage('assets/image_not_found.png'));
              }
              return Column(
                children: [
                  Expanded(
                    child: InkWell(
                      onLongPress: () {
                        if (selected) return;
                        widget.setSelectedFolders(true, widget.folder.id);
                        selected = true;
                        setState(() {});
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) {
                              // If this is an image, navigate to ImageScreen
                              return FolderScreen(
                                  assets: assets,
                                  folderName: widget.folder.name);
                            },
                          ),
                        );
                      },
                      // child: Image.file(assets[0].)
                      /// The line `// child: Ges(` in the code snippet you provided seems to be a
                      /// commented-out line of code. It looks like there might have been a typo or an
                      /// incomplete statement in that line.
                      child: Stack(
                        children: [
                          SizedBox(
                              width: double.infinity,
                              child: Image.memory(bytes, fit: BoxFit.cover)),
                          widget.isSelectedFolders
                              ? Positioned(
                                  top: -10,
                                  left: -10,
                                  child: Checkbox(
                                    value: selected,
                                    onChanged: (value) {
                                      selected = value!;
                                      widget.setSelectedFolders(
                                          value, widget.folder.id);
                                      setState(() {});
                                      // _localization.translate('en');
                                    },
                                  ),
                                )
                              : const SizedBox(),
                          //     // Wrap the image in a Positioned.fill to fill the space
                          //     Positioned.fill(
                          //       child: Image.memory(bytes, fit: BoxFit.cover),
                          //     ),
                          //     // Display a Play icon if the asset is a video
                          //     if (asset.type == AssetType.video)
                          //       Positioned(
                          //         bottom: 5,
                          //         right: 5,
                          //         child: Container(
                          //           decoration: const BoxDecoration(boxShadow: [
                          //             BoxShadow(
                          //               color: Colors.blueAccent,
                          //               blurRadius: 10.0,
                          //               spreadRadius: 2.0,
                          //             ),
                          //           ]),
                          //           child: Text(Duration(seconds: asset.duration)
                          //               .toString()
                          //               .split('.')
                          //               .first
                          //               .padLeft(8, "0")
                          //               .substring(1)),
                          //         ),
                          //       )
                        ],
                      ),
                    ),
                  ),
                  Text(widget.folder.name.length > 10
                      ? '${widget.folder.name.substring(0, 10)}...'
                      : widget.folder.name)
                ],
              );
            },
          );
  }
}