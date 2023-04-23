String truncateString(String inputString, int length) {
  if (inputString.length <= length) {
    return inputString;
  } else {
    return '${inputString.substring(0, length - 3)}...';
  }
}
