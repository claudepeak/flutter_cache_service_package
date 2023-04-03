# Cache Service

This service searches for a file in the cache from the given URL, and returns it if it exists. 

If the file does not exist in the cache, it downloads it, saves it, and returns it.

This way, the existence of the file can be checked in the cache first, and downloaded if it is not there.

Separating the cache mechanism into a separate class improves the readability of the code.

**E.g :**

    final cacheService = CacheService();
    final file = await cacheService.getOrDownloadFile('http://example.com/file.mp3', 'file.mp3');


### Methods 

`getOrDownloadFile(String url, String fileName, [bool? cacheEnabled, bool? isFile])` 

Searches for a file in the cache from the given URL, and returns it if it exists. If the file does not exist in the cache, it downloads it, saves it, and returns it. By this way, the existence of the file can be checked in the cache first, and downloaded if it is not there. Separating the cache mechanism into a separate class improves the readability of the code.

#### Parameters:
-   url : String - URL of the file to be downloaded
-   fileName : String - Name of the file
-   cacheEnabled : bool? (optional) - Is caching enabled?
-   isFile : bool? (optional) - Is the downloaded data a file or text.

#### Return Value:

-   CacheBaseModel - CacheBaseModel object containing the status (whether the operation is successful or not) and file information.
