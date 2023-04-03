import 'package:flutter/material.dart';
import '../cache_service.dart';
import '../model/cache_base_model.dart';

class CachedImageLoader extends StatefulWidget {
  final String url;
  final String fileName;
  final bool? cacheEnabled;
  final Widget? errorWidget;
  final BoxFit? fit;

  const CachedImageLoader({
    Key? key,
    required this.url,
    required this.fileName,
    this.cacheEnabled,
    this.errorWidget,
    this.fit,
  }) : super(key: key);

  @override
  State<CachedImageLoader> createState() => _CachedImageProviderState();
}

class _CachedImageProviderState extends State<CachedImageLoader> {
  final cacheService = CacheService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: cacheService.getOrDownloadFile(widget.url, '${widget.fileName}.png', widget.cacheEnabled),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final cacheBaseModel = snapshot.data as CacheBaseModel;

          return cacheBaseModel.isCached
              ? Image.file(
                  cacheBaseModel.file,
                  errorBuilder: (context, error, stackTrace) => widget.errorWidget ?? const Icon(Icons.error_outline),
                  fit: widget.fit ?? BoxFit.cover,
                )
              : Image.network(
                  widget.url,
                  fit: widget.fit ?? BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => widget.errorWidget ?? const Icon(Icons.error_outline),
                );
        } else if (snapshot.hasError) {
          return widget.errorWidget ?? const Icon(Icons.error_outline);
        } else {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
      },
    );
  }
}
