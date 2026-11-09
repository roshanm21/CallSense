class RedFlag {
  const RedFlag(this.phrase, this.points, this.explanation);

  final String phrase;
  final int points;
  final String explanation;
}

const redFlags = <RedFlag>[
  RedFlag('one-time password', 30, 'Requests a one-time password or verification code.'),
  RedFlag('otp', 25, 'Mentions an OTP or verification code.'),
  RedFlag('share your pin', 35, 'Asks you to disclose a private PIN.'),
  RedFlag('account will be blocked', 25, 'Uses an urgent account-blocking threat.'),
  RedFlag('urgent action required', 25, 'Pressures you to act immediately.'),
  RedFlag('claim your prize', 20, 'Promises a prize that may be used to lure you in.'),
  RedFlag('you have won', 15, 'Claims you have won something unexpectedly.'),
  RedFlag('send money', 25, 'Asks for a money transfer.'),
  RedFlag('payment immediately', 25, 'Pressures you to make an immediate payment.'),
  RedFlag('remote access', 30, 'May be asking you to give someone control of your device.'),
  RedFlag('click this link', 15, 'Asks you to follow a link.'),
  RedFlag('bank details', 25, 'Requests sensitive financial information.'),
];
