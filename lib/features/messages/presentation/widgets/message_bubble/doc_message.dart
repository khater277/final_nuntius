import 'dart:async';
import 'dart:io';

import 'package:final_nuntius/core/shared_widgets/text.dart';
import 'package:final_nuntius/core/utils/app_colors.dart';
import 'package:final_nuntius/core/utils/app_fonts.dart';
import 'package:final_nuntius/core/utils/app_values.dart';
import 'package:final_nuntius/core/utils/icons_broken.dart';
import 'package:final_nuntius/features/messages/data/models/message/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:path/path.dart';

class DocMessage extends StatefulWidget {
  const DocMessage({
    super.key,
    required this.message,
  });

  final MessageModel message;

  @override
  State<DocMessage> createState() => _DocMessageState();
}

class _DocMessageState extends State<DocMessage> {
  DefaultCacheManager defaultCacheManager = DefaultCacheManager();
  Future<File> getFile() async {
    return await CachedFileService(defaultCacheManager)
        .getFile(widget.message.media!);
  }

  // @override
  // void initState() {

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final file = await getFile();

        final filePath = file.absolute.path;
        // print(filePath);
        String x = basename(file.path);
        // final directory = await getExternalStorageDirectory();
        // final y = '${directory!.absolute.path}/$x';
        // print('$y/$x');
        // await DefaultCacheManager().getSingleFile(widget.message.media!);
        // final filex = File(y);
        // await filex.open();
        // print(filex.open());
        // OpenFile.open(y);

        final Directory? directory = await getExternalStorageDirectory();
        OpenFile.open("${directory!.path}/${widget.message.message!}");
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(
            IconBroken.Document,
            color: AppColors.white,
            size: AppSize.s20,
          ),
          SizedBox(width: AppWidth.w4),
          Flexible(
            fit: FlexFit.loose,
            child: SmallHeadText(
              text: widget.message.message!,
              size: FontSize.s13,
              maxLines: 1000000,
              isUnderLine: true,
            ),
          ),
          SizedBox(width: AppWidth.w5),
          SecondaryText(
            text: DateFormat.jm().format(DateTime.parse(widget.message.date!)),
            color: AppColors.grey,
            size: FontSize.s10,
          )
        ],
      ),
    );
  }
}

abstract class FileService {
  Future<File> getFile(String fileUrl);
}

class CachedFileService extends FileService {
  final BaseCacheManager _cacheManager;

  CachedFileService(this._cacheManager);

  @override
  Future<File> getFile(String fileUrl) async {
    final fileInfo = await _cacheManager.getFileFromCache(fileUrl);

    if (fileInfo == null) {
      print('[VideoControllerService]: No file in cache');

      print('[VideoControllerService]: Saving file to cache');
      await _cacheManager.downloadFile(fileUrl);
      // unawaited(_cacheManager.downloadFile(fileUrl));

      return _cacheManager.getSingleFile(fileUrl);
    } else {
      print('[VideoControllerService]: Loading file from cache');
      return _cacheManager.getSingleFile(fileUrl);
    }
  }
}
