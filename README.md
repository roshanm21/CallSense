# CallSense — Know before you trust
10 Nov 2026
# The problem
Phone and message scams are now the most common crime most Indians will face. In 2025, Indians lost about ₹22,495 crore to cyber fraud across roughly 2.81 million reported cases, and the national 1930 cybercrime helpline logged over 32 million calls. The fastest-growing tactics are fake job and internship offers that demand "registration" or "training" fees, fake-police "digital arrest" calls, and impersonation of real banks and companies.
The people who fall for these aren't careless — they're ordinary students, job-seekers, and parents who have no quick way to check whether an offer letter, a WhatsApp message, or a caller is real. By the time they ask someone, the money is often already sent.
# The solution
CallSense is a privacy-first Android app that lets anyone check a suspicious message, offer letter, screenshot, or link in seconds — before they act on it.
You paste a message or share a screenshot into CallSense, and it instantly flags the scam signals inside it: demands for money, requests for OTP or PIN, fake urgency, threats of arrest, personal-email senders, shortened links, and more. It gives a clear verdict — Safe, Suspicious, or Scam — and explains why, in plain language, so the user actually learns the warning signs.
For job and internship offers, CallSense goes further: it verifies the company online. It searches the web for the company's real presence and checks how old the company's website domain is (scam fronts are usually registered weeks ago), and warns if something doesn't add up.
If someone is already on a suspicious call, CallSense gives them a guided question menu — the exact things to ask a real recruiter or bank officer that a scammer can't answer — and a one-tap way to alert a family member or guardian and to report to the 1930 helpline.
# How it works
1. Share or paste — Send any message, offer letter, or screenshot into CallSense from any app, or paste it directly.
2. On-device scan — CallSense reads the text (using on-device OCR for images) and runs it through its scam-detection engine. This happens entirely on the phone.
3. Verdict and reasons — You get a Safe / Suspicious / Scam verdict with a plain-language list of every red flag found.
4. Company check (for offers) — If it's a job or internship, CallSense verifies the company online and checks the website's domain age.
5. Act safely — Use the question menu to test the caller, alert your family, or report to 1930.
Privacy by design
This is the core promise. Scam-checking apps that read your messages are themselves a privacy risk — so CallSense is built to not be one.
• Detection runs on your phone. The scam-detection engine and the text-reading (OCR) never send your messages or images anywhere.
• Only the company name leaves the phone — and only when you're verifying an employer. Nothing else.
• Verdicts are stored, not content. Family alerts carry only the verdict and the reasons ("Scam — asked for a registration fee"), never the original message text or any audio.
• No account, no tracking. Anonymous sign-in, with database access locked down by row-level security.
# Tech stack
• Flutter — Android app, with a Flutter web demo for presentation
• On-device ML Kit — text recognition from screenshots
• Supabase — PostgreSQL with row-level security, Edge Functions, anonymous auth, and Realtime for live guardian alerts
• Tavily Search API — company web-presence verification (key stays server-side, never in the app)
• RDAP — website domain-age lookups
# Roadmap
• Now: Message, offer-letter, screenshot, and link checking; company verification; question menu; family alerts; 1930 reporting.
• Next: Live guardian alerts over Realtime; a shared family dashboard; expanded scam-pattern rules trained on real reported cases.
• Future (needs partnership): Live call-audio analysis. Android blocks third-party apps from capturing call audio, so this is only possible through an OEM or telecom partnership — a deliberate future goal, not a false promise.
# Why it matters
Awareness campaigns work — digital-arrest scam cases fell about 86% in 2025 after public warnings. But awareness only helps at the exact moment of decision. CallSense puts that moment of "wait, let me check" directly in the user's hand, for every suspicious message, with an answer in seconds and an explanation that makes them harder to fool next time.
