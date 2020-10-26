RegExp usernameRegex = RegExp(
  r"^[a-zA-Z][a-zA-z_0-9]{3,18}$",
  caseSensitive: false,
  multiLine: false,
);
RegExp emailRegex = RegExp(
  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  caseSensitive: false,
  multiLine: false,
);
RegExp phoneRegex = RegExp(
  r"\+(9[976]\d|8[987530]\d|6[987]\d|5[90]\d|42\d|3[875]\d|2[98654321]\d|9[8543210]|8[6421]|6[6543210]|5[87654321]|4[987654310]|3[9643210]|2[70]|7|1)\d{1,14}$",
  caseSensitive: false,
  multiLine: false,
);
