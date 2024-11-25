String convertToGdriveDirectLink(String url) {
  // Regular expression to match Google Drive file link
  const drivePattern =
      r'^https:\/\/drive\.google\.com\/file\/d\/[a-zA-Z0-9_-]+\/view.*$';

  // Check if the URL matches the Google Drive pattern
  if (RegExp(drivePattern).hasMatch(url)) {
    // Extract the file ID using a RegExp
    RegExp regExp = RegExp(r'd/([a-zA-Z0-9-_]+)');
    Match? match = regExp.firstMatch(url);

    if (match != null) {
      String fileId = match.group(1)!;
      // Construct and return the direct download link
      return 'https://drive.google.com/uc?export=download&id=$fileId';
    } else {
      // Return an error message if the file ID is not found
      return 'Invalid Google Drive link';
    }
  } else {
    // Return the original URL if it doesn't match the Google Drive pattern
    return url;
  }
}
