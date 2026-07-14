# Vitala_Amanah_Master_Build_Prompt.md

# Vitala Amanah — Master Build Prompt for Codex / Sites

Copy everything below this line into Codex or Sites.

---

## ROLE AND OBJECTIVE

You are a senior product designer, full-stack engineer, security architect and Malaysian fintech/estate-planning UX specialist. Build a polished, mobile-responsive SaaS web application called **Vitala Amanah**.

**Tagline:** Your life, wealth and legacy—organised securely.

Vitala Amanah is a Malaysian-first, inclusive digital legacy and family wealth command centre for Muslim and non-Muslim users. It helps users inventory assets and liabilities, organise insurance/takaful and hibah information, store critical documents and instructions, plan retirement, nominate trusted people, and prepare their family for emergencies or death.

The product is an organisational and planning platform. It must not present itself as a lawyer, licensed financial adviser, insurer, trustee, executor, will-writing service or password manager unless those regulated capabilities are later supplied by appropriately licensed partners. Display clear disclaimers wherever AI, legal, financial, insurance/takaful, hibah, nomination or inheritance guidance appears.

Build a working MVP with realistic sample data and production-quality UI. Do not create a static landing page only. Include the public website, authentication screens, onboarding and a functional logged-in application prototype.

## BRAND AND DESIGN

- Brand: Vitala Amanah
- Positioning: premium security and clarity at an accessible Malaysian price
- Personality: trustworthy, calm, protective, modern, discreet and family-centred
- Visual direction: elegant Malaysian contemporary, combining a premium secure-vault experience with subtle local character; do not substitute a generic fintech template
- Visual style: restrained glass-like layered cards, generous spacing, strong readability and excellent mobile usability; use blur/transparency sparingly and always provide solid high-contrast fallbacks
- Core colours: midnight blue, jade and champagne. Suggested tokens: midnight `#0B1736`, midnight surface `#122348`, jade `#179477`, deep jade `#0F6F5D`, champagne `#D6B978`, ivory `#F7F5EF`, white `#FFFFFF`, plus accessible semantic status colours
- Typography: modern sans-serif such as Inter or Geist
- Logo direction: an elegant “Vitala Amanah” wordmark with a restrained songket-inspired detail; create it as a clean brand treatment, not a religious emblem or busy ornamental logo
- Malaysian identity: use subtle songket-inspired geometry as low-opacity background texture, dividers or edge detailing; never reduce legibility or dominate the interface
- Hero visual: a premium secure digital-vault concept using layered light, encrypted-document cues and subtle songket geometry; avoid literal bank safes, padlocks as the only idea, fear-based imagery or funeral imagery
- Avoid gloomy colours, excessive Islamic ornamentation, generic stock-photo clutter and fear-based marketing
- Support English and Bahasa Melayu using a visible language switcher
- Use Malaysian currency formatting (RM) and dates (`DD MMM YYYY`)
- Meet WCAG AA expectations, including keyboard navigation, visible focus, labelled forms and sufficient contrast
- Writing tone: clear and professional with gentle warmth; use calm guidance, short explanations and reassuring confirmations without becoming childish or overly casual
- Support light mode, dark mode and a persistent larger-text accessibility mode; respect system preferences while allowing manual override
- Provide a reduce-motion setting and respect the operating system's reduced-motion preference
- Use moderate interactive motion for route transitions, progress, card expansion and success feedback; keep motion purposeful and maintain fast perceived performance

### Interaction system

- Use a persistent hamburger menu in the top-left app header to expand or collapse the left navigation menu
- Desktop navigation: expandable/collapsible left sidebar with icons and labels; expanded state shows section names and current location, collapsed state shows accessible icon tooltips
- Tablet and mobile navigation: the same hamburger button opens the left navigation as an overlay drawer with backdrop, close button, swipe/keyboard-safe dismissal and focus trapping; selecting a destination closes the drawer
- Preserve navigation state appropriately, highlight the active page, support nested sections without overcrowding, and keep Settings, Help and Sign Out at the bottom
- Long forms: guided step-by-step flows with progress indicator, autosaved drafts, explicit “Save and continue later,” validation per step and a final review screen
- Dashboard: simple summary with guided next steps, not an overwhelming analytics wall
- Data visualisation: balanced charts with accompanying plain-language explanations, accessible legends, values available in text/table form and expandable detail
- Vitala Guide: floating assistant button available throughout the logged-in app; show unread/activity state subtly and open an accessible assistant panel without covering essential controls
- Use skeleton, empty, success, warning and recoverable-error states consistently
- Confirm high-risk actions with plain-language summaries of what will happen

### Mobile optimisation

- Design mobile-first for common widths from 320 px upward and verify phone, tablet, laptop and desktop layouts
- Use touch targets of at least 44 by 44 px, readable default text, safe-area padding and no horizontal page scrolling
- Convert wide tables into stacked summary cards with an optional full-table view
- Use bottom sheets or full-screen mobile dialogs for complex selections; never show cramped desktop modals on phones
- Keep primary form actions in a safe sticky footer when helpful, without hiding content or the device keyboard
- Ensure dropdowns, date pickers, file upload, camera document capture and multi-select controls work on Android Chrome and iPhone Safari
- Support taking a document photo, previewing it, rotating/cropping it and confirming before encrypted upload
- Provide responsive charts with text summaries and accessible data tables
- Autosave long forms and recover drafts after accidental closure or poor connectivity
- Show upload progress, allow safe retry and prevent duplicate submission
- Use progressive loading and pagination so large asset or document lists remain fast
- Prepare installable PWA behaviour for a later milestone, including app icons, manifest and offline-safe shell, but never cache decrypted documents or secrets offline by default

## PUBLIC WEBSITE

Create these public sections/pages:

1. Home with hero, core value proposition, trust indicators and CTAs: “Start Free” and “See How It Works”.
2. How It Works: Record, Protect, Share, Prepare.
3. Features grouped into Wealth, Protection, Legacy, Family and Retirement.
4. Security and Privacy page explaining encryption, access controls, audit history, backups and account recovery in plain language.
5. Pricing with Free, Pro and Family plans and a monthly/annual toggle.
6. Professional Partners page for future verified referrals.
7. FAQ, Contact, Terms, Privacy, AI Disclaimer, Financial Disclaimer and Legal Disclaimer.

Do not claim certifications, bank-grade security, zero-knowledge encryption, PDPA compliance or end-to-end encryption unless the implementation genuinely provides it. Phrase planned security controls accurately.

## RECOMMENDED MALAYSIAN PRICING

Use introductory pricing:

| Plan | Monthly | Annual | Purpose |
|---|---:|---:|---|
| Free | RM0 | RM0 | Let users experience the core value |
| Pro | RM19.90 | RM199 | Complete planning for one adult |
| Family | RM39.90 | RM399 | Shared family planning with 2 adult seats and 3 dependent/viewer seats |

- Additional Family adult seat: RM8/month or RM80/year.
- Optional one-time add-ons later: professional document review, estate-readiness report, extra encrypted storage, assisted onboarding, property valuation referral and retirement consultation.
- Referral revenue may be earned from verified professional partners, but referrals must be transparently labelled.
- Show “Founding Member” launch pricing without fake countdowns or false scarcity.

### Pricing comparison UI

Create a polished, responsive comparison experience on `/pricing`, during onboarding and inside Billing settings:

- show Free, Pro and Family as side-by-side cards on desktop and easy-to-swipe/stacked cards on mobile
- include monthly/annual toggle with the exact annual saving shown in RM and percentage; do not invent a discount
- mark Pro as “Most Popular” and Family as “Best for families” without making either visually deceptive
- show price, billing period, included adult/dependant seats, storage, AI allowance, trusted contacts, reports, retirement planning, emergency access and family-sharing features
- use simple checkmarks, clear numerical limits and short explanations; avoid vague claims such as “everything unlimited”
- include an expandable “Compare every feature” table below the cards
- keep the plan names visible in a sticky table header on long desktop comparisons
- on mobile, provide a plan selector so users can compare any two plans without horizontal overflow
- include a plain-language recommendation quiz: “Just me,” “I need full planning,” or “I am planning with family,” while allowing the user to choose any eligible plan
- show secure-payment reassurance, cancellation/grace-period summary, refund-policy link and tax/fee wording where applicable
- CTAs: “Start Free,” “Upgrade to Pro,” and “Choose Family”
- authenticated users see “Current plan,” renewal date and upgrade/downgrade impact

### Contextual upgrade and paywall UX

Prompt users to upgrade only when a paid benefit is relevant or a Free limit is reached. Do not repeatedly interrupt normal use.

Upgrade trigger examples:

- attempting to add more than the Free asset/liability limit
- attempting to add a fourth insurance/takaful policy
- attempting to exceed the Free trusted-contact or storage limit
- opening the full AI retirement planner
- requesting a full-detail PDF, encrypted backup or advanced report
- trying to create custom continuity-release rules
- inviting a second adult or creating a shared family vault
- using paid AI document scans or exceeding the monthly AI allowance
- accessing Secure Vault, advanced reminders or professional-priority features when not included

Every upgrade prompt must:

- state what the user tried to do
- explain which plan unlocks it and why it is useful
- show the exact price and billing period
- provide “Upgrade now,” “Compare plans” and “Not now” actions
- preserve the user's current draft/action so it can continue after successful payment
- never delete, hide or hold existing user data hostage
- avoid countdowns, guilt, false urgency, confirm-shaming and repeated prompts after dismissal
- apply a reasonable cooldown after “Not now” except when the user actively retries the restricted action

Use three presentation levels:

1. **Inline notice** for approaching a limit, such as 8 of 10 records used.
2. **Upgrade modal or bottom sheet** when the user directly attempts a restricted action.
3. **Full comparison page** when the user selects Compare Plans or Billing.

After payment:

- verify payment server-side before changing entitlements
- show a clear success state and new plan/renewal details
- automatically return to the preserved action or draft
- send a receipt/access email
- record the entitlement change in the audit history

If payment fails or is cancelled, preserve the draft and return the user safely with a retry option. Never show Pro access solely because the browser returned from a payment-success page.

### Plan limits

**Free**
- 1 user
- Up to 10 asset/liability records
- Up to 3 insurance/takaful policies
- Up to 2 trusted contacts
- 100 MB document storage
- Basic net-worth dashboard
- Basic legacy-readiness checklist
- Basic retirement estimate
- No password or secret-value storage in the initial MVP
- No automated emergency release

**Pro**
- 1 adult user
- Unlimited structured records subject to fair use
- 2 GB private storage
- Full insurance/takaful, hibah, nomination and legacy modules
- Complete AI retirement planner
- AI document extraction and readiness analysis
- Up to 10 trusted contacts
- Custom information-sharing rules
- Exportable family emergency pack and estate summary
- Renewal and expiry reminders
- Version history and priority support

**Family**
- Everything in Pro
- 2 adult seats plus 5 dependent profiles/viewer seats
- Extra paid seats
- 5 GB total storage shared across the household and both adult vaults
- Separate private vault for each adult
- Shared household vault
- Granular category-based permissions
- Family dashboard and readiness score
- Shared emergency plan
- No adult can automatically see another adult’s private information

## AUTHENTICATION AND ONBOARDING

Create a premium dedicated authentication experience with clear **Sign In** and **Sign Up** tabs/pages. Include forgot password, email verification, recovery-code entry, trusted-contact recovery initiation and optional passkey/2FA UI. Do not use fake authentication in production; for prototype mode, clearly label demo behaviour.

### Login and sign-up UI

- `/login`: email and password, Google sign-in, remember-device option, show/hide password, Forgot Password, Sign Up link and security reassurance
- `/signup`: full name, email, password strength guidance, confirm password, country/residency, language, required acceptance of Terms and Privacy, optional marketing consent kept separate, and Create Account
- Keep Sign In and Sign Up visually distinct; do not combine them into a confusing single form
- Redirect authenticated users away from public auth pages and return users to their intended protected page after successful sign-in
- Use neutral error messages that do not reveal whether an email account exists
- Rate-limit attempts, add bot protection where appropriate and notify users of important new-device sign-ins
- Require verified email before uploading real documents, inviting trusted contacts, exporting full reports or changing recovery rules
- Re-authenticate before revealing sensitive values, downloading full-detail reports, changing trusted contacts, managing encryption recovery or closing the account
- Provide session/device management in Settings with device name, approximate location, last active time and remote sign-out

Account recovery must support verified email, single-use recovery codes and an already-enrolled trusted contact. A trusted contact alone cannot recover an account. Apply a waiting period and notify all existing verified channels when trusted-contact recovery begins. Recovery of login access and recovery of the client-encrypted document vault are separate security operations and must be designed and tested separately.

Onboarding steps:

1. Language and residency.
2. Individual or family setup.
3. Muslim, non-Muslim or “skip/prefer not to say”; use only to tailor optional guidance.
4. Household and dependants.
5. Trusted contacts.
6. Initial goals: organise assets, protect family, retirement planning, insurance review, hibah/legacy preparation or emergency readiness.
7. Privacy preferences and consent.
8. First guided task.

After basic profile setup, ask the user to choose a primary goal—organise assets, protect family, prepare an emergency pack, review insurance/takaful, organise hibah/nomination, or plan retirement—then generate a short personalised checklist. The user can change goals later and may complete checklist items in any order.

Include a “Skip for now” option and save progress.

## MAIN APPLICATION NAVIGATION

Use a responsive sidebar on desktop and bottom navigation plus a More menu on mobile:

- Home
- My Wealth
- Protection
- Legacy
- Retirement
- Family
- Documents
- AI Adviser
- Reminders
- Settings

## HOME DASHBOARD

Show:

- Total assets, liabilities and estimated net worth
- Liquid versus illiquid assets
- Insurance/takaful coverage summary
- Nomination and hibah status
- Retirement readiness indicator
- Legacy Readiness Score from 0–100 with transparent contributing factors
- Upcoming renewals and expiries
- Missing-information alerts
- Recently updated records
- Quick-add actions
- “If something happens today” readiness summary
- one dominant “Next best step” card derived from the user's selected goal and missing information
- a short checklist with visible progress and the ability to defer or change the current goal

Do not imply that the readiness score is legal validation.

## MY WEALTH

Support CRUD, search, filters, sorting, attachments, notes, ownership percentage, beneficiaries/intended recipients, contacts and record-level permissions.

### Property

Capture property type, name, address, country/state, title/strata number, tenure, purchase date and price, current estimated value, valuation date/source, ownership structure and percentage, joint owner, loan provider, outstanding financing, instalment, rental status, tenant/agent, rental income, maintenance fee, quit rent, assessment, insurance/takaful, key document locations and person to contact.

### Cash and banking

Bank/provider, account nickname, masked account number, account type, branch, ownership, approximate balance, currency, nominee status, contact and document location. Never display full account numbers by default.

### Investments

Shares, ETFs, unit trusts, ASB/ASM where relevant, bonds/sukuk, robo-advisers, private equity, cryptocurrency and other investments. Capture platform/broker, masked account identifier, holdings, quantity, cost, estimated value, nominee, custodian, contact and access instructions without storing raw seed phrases.

### Retirement accounts

EPF/KWSP, PRS, pensions and employer retirement benefits: current balance, contribution, projected growth, nomination status, last updated date and documents.

### Business interests

Company name, registration number, ownership percentage, partners/directors, estimated value, shareholder agreement, key-person cover, succession instruction, accountant/company secretary and essential documents.

### Vehicles and valuables

Vehicle, jewellery, collectibles, equipment and other valuable property with ownership, value, financing, insurance and location.

### Receivables and money owed to the user

Debtor, amount, agreement, due date, supporting evidence and contact.

### Liabilities

Mortgages, vehicle loans, personal loans, credit cards, business guarantees, taxes, education loans and private debts. Capture lender, masked account, outstanding balance, rate, instalment, maturity, co-borrower/guarantor, settlement coverage and contact.

## PROTECTION: INSURANCE AND TAKAFUL

Create a policy register for life, family takaful, medical, critical illness, personal accident, mortgage/loan cover, motor, home/fire, travel, business/key-person and other coverage.

Fields:

- insurer/takaful operator
- policy/certificate type and masked number
- policy owner, life assured/covered person and payer
- start, renewal and expiry dates
- premium/contribution and payment frequency
- sum assured/covered amount
- riders and major benefits
- exclusions/important notes entered by user
- agent/adviser and claims contact
- nominee and beneficiary information as recorded by user
- assignment/trust status
- payment method without full card data
- attached policy schedule and nomination form
- last review date
- claim instructions
- status: active, pending, lapsed, matured or cancelled

Functions:

- coverage summary by person and risk category
- renewal, premium and review reminders
- duplicate or apparent coverage-gap flags, clearly marked as informational
- AI policy-document extraction requiring user confirmation
- claim-readiness checklist
- emergency “Who to call” card
- comparison based only on user-entered policy facts; no product selling or personalised regulated advice

## HIBAH, NOMINATION AND LEGACY PLANNING

Separate these concepts clearly. Do not state that nomination automatically determines beneficial ownership, and do not treat hibah, wills/wasiat, trusts and faraid/distribution rules as interchangeable.

### Hibah register

- hibah type/category selected from configurable options
- provider/law firm/trust company
- donor and intended recipient(s)
- asset covered
- document date and reference
- conditional notes as stated in the document
- trustee/custodian if applicable
- document storage location
- witness and professional contact information
- review status and last professional review
- completion checklist

### Nomination register

Track nominations for EPF, insurance/takaful, unit trusts, cooperative accounts and other institutions. Capture institution, account/policy, nominee(s), percentage, relationship, nomination date, last checked date and attached confirmation. Show reminders to review after marriage, divorce, birth, death or major life changes.

### Legacy documents

Track will/wasiat, trust, guardianship wishes, executor/wasi, power of attorney or other authority documents, advance healthcare preferences where legally appropriate, funeral/burial preferences, organ-donation information, pet care and personal messages.

For every record show:

- Draft / Completed / Professionally reviewed / Needs review
- date, jurisdiction, professional, witnesses, physical original location and encrypted copy
- intended executor, trustee, guardian or contact
- review reminder

The app organises information and generates preparation checklists; it must not claim a document is legally valid.

## CONTACTS AND PEOPLE DIRECTORY

Support emergency contact, spouse/partner, family member, nominee, beneficiary/intended recipient, executor/wasi, trustee, guardian, lawyer, financial planner, insurance/takaful agent, accountant, company secretary, banker, property agent, tenant, business partner, doctor and other roles.

Capture verified mobile/email, relationship, preferred language, role, records connected to that person and what they are authorised to access. Allow one person to have multiple roles.

## FAMILY ACCESS AND EMERGENCY RELEASE

Implement three access modes:

1. Immediate shared access for selected records.
2. Emergency-only access to a limited emergency pack.
3. Conditional release based on owner-defined rules.

Custom rules may include inactivity duration, owner check-ins, waiting period, one or two trusted-person approvals, identity verification and official-document review by an authorised process. The product must never release secrets merely because one person reports a death.

Essential controls:

- owner chooses access per category or record
- default is no access
- adult family members maintain separate private vaults
- preview exactly what each person will see
- revoke access at any time
- trusted-contact acceptance and periodic reconfirmation
- tamper-evident audit history
- owner notifications for access requests and rule changes
- cooling-off period after changing high-risk release settings
- recovery and dispute workflow

For the MVP, simulate conditional release workflows without automatically releasing real secrets. Mark manual verification steps clearly.

### MVP Emergency Pack

- The owner pre-authorises the recipient and the exact information before any emergency occurs.
- Default content: trusted and emergency contacts, insurance/takaful policy summary, claims contacts, and a redacted asset summary.
- Exclude passwords, PINs, complete account numbers, secret fields and full source documents by default.
- The recipient must accept an invitation and verify both email and mobile number using OTP.
- “Immediate access” means immediate access to the pre-authorised pack; it never unlocks the complete vault.
- Let the owner preview the recipient view, revoke access and regenerate the pack after changes.
- Log every invitation, verification, view, download, revocation and failed access attempt.

## VITALA SECURE VAULT: PASSWORD MANAGER AND DIGITAL LEGACY

Build a complete client-encrypted password manager as a separately gated security milestone. The owner explicitly chose Vitala's own encrypted vault rather than relying only on external password managers. Never enable real credential storage in public production until the cryptographic design, account recovery, emergency release, web application and Chrome extension have passed independent security review.

### Vault item types

- website/application login
- secure note
- identity record
- Wi-Fi credential
- software licence
- recovery codes
- bank/account reference with strong warnings
- optional payment card, disabled by default per user
- document/attachment only when the encrypted file architecture is active
- custom fields, including concealed and non-concealed values

Never store CVV after card entry, and do not encourage storage of banking PINs, crypto seed phrases or private keys. If high-risk secret notes are technically permitted, display explicit warnings and exclude them from AI, normal search indexing, reports and emergency access unless separately authorised.

### Core password-manager functions

- create, view, edit, duplicate, archive and delete vault items
- folders, collections, favourites, tags, search and filters
- strong password and passphrase generator with configurable rules
- password-strength, age, reuse and compromised-password indicators using a privacy-preserving method
- username generator and optional masked-email integration point
- copy with timed clipboard clearing where supported
- reveal requiring recent vault unlock
- item history and restoration without exposing old secrets to administrators
- automatic lock based on inactivity, browser close, device restart and user preference
- biometric/passkey-assisted local unlock where supported, without weakening the master-secret design
- secure sharing to another Vitala adult through recipient public-key encryption, revocable access and item-level audit history
- secure notes and recovery-code display with one-time/reveal controls
- encrypted export and emergency backup kit
- never include vault secrets in ordinary PDFs, CSV exports, logs, analytics, crash reports, support tools or AI requests

### Cryptographic and key-management requirements

- encrypt and decrypt vault secrets only in trusted user clients using reviewed standard cryptographic libraries and authenticated encryption
- derive the user's key-encryption key from a dedicated vault master password using a current memory-hard password-based KDF with reviewed parameters; do not invent cryptography
- use random per-item data keys or an equivalently reviewed envelope-encryption design
- the server stores ciphertext, non-sensitive operational metadata and wrapped keys only
- Vitala administrators, database administrators and support staff cannot decrypt vault contents
- maintain cryptographic versioning and a migration strategy for future algorithm/parameter changes
- separate login authentication from vault decryption; resetting the login password must not silently reset or expose the vault
- provide recovery codes and owner-prepared emergency recovery material
- use device enrolment, device revocation and re-keying after compromise or recovery
- protect against replay, rollback, item swapping and unauthorised ciphertext replacement
- publish a threat model and obtain independent cryptography/application security review before real-user launch

### Import and export

- support encrypted client-side processing of CSV imports from major password managers using explicit source templates
- parse and validate imports locally, preview the mapped fields, warn about unsupported fields and require confirmation before saving
- never upload the plaintext CSV to application storage; clear temporary in-memory/file references when processing completes
- warn users to securely delete the original plaintext CSV after a successful import
- provide duplicate detection and a reversible import batch until the user confirms completion
- export only through recent re-authentication and vault unlock; encrypted export is the default
- plaintext CSV export, if provided at all, requires repeated warnings, explicit confirmation, no server persistence and clear safe-deletion guidance

### Optional payment cards

- card storage is disabled by default and must be enabled by each user with an educational warning
- store cardholder name, card label, encrypted full card number, expiry and optional billing notes
- never request or persist CVV/CVC
- mask the number by default, require recent vault unlock to reveal or copy, and exclude it from emergency packs and reports by default
- do not claim PCI compliance or enable payment-card storage in production until the applicable compliance scope has been professionally assessed

### Continuity and emergency release for the secure vault

- support death and incapacity as distinct continuity events
- any owner-selected verified adult may be appointed as continuity lead; allow backups
- the owner customises required evidence and chooses the waiting period
- apply one emergency-release rule to the entire password vault in the first version
- during the waiting period, notify the owner through every verified channel and allow cancellation from any verified device
- require recipient email and mobile OTP verification, authenticated evidence submission and complete audit history
- the recipient's ability to decrypt after an approved release must be prepared cryptographically before the event through wrapped recovery material; administrators must never decrypt and re-send plaintext secrets
- provide safety warnings when the owner's selected evidence or waiting period is weak and enforce a configurable non-zero minimum waiting period
- separate temporary incapacity access from permanent death succession; temporary access should be revocable and require re-keying/review when the owner returns
- children are configured individually by the owner, including recipient, guardian/intermediary, eligible age, accessible categories and backup arrangement
- never release the password vault through the basic immediate Emergency Pack

### Digital legacy instructions

For every digital account, also support:

- service name and category
- owner, username/email hint and recovery method
- 2FA/passkey status
- subscription and billing status
- desired action: continue, transfer, memorialise, archive, download or delete
- responsible person and backup
- links to Google Inactive Account Manager, Apple Legacy Contact or equivalent external setup status
- last tested/reviewed date

## DOCUMENT VAULT

Folders/categories: identity, property, banking, investments, business, insurance/takaful, hibah, nominations, legacy, tax, health, family and other.

Provide upload, preview, rename, tag, expiry date, linked records, version history, permissions and download. Support PDF and common image/document types with strict validation and malware-scanning integration points.

Security requirements:

- private storage with short-lived signed access
- encryption in transit and at rest
- client-side encryption architecture for highly sensitive files when technically supported
- no public file URLs
- redact sensitive values in logs
- explicit consent before sending a document to AI
- allow users to delete AI-extracted content
- retention and permanent-deletion controls

### Administrator privacy boundary

- Vitala administrators must never be able to open or preview users' document contents.
- Encrypt documents in the user's browser before upload using reviewed standard cryptographic libraries and authenticated encryption.
- Store only ciphertext in object storage; do not place document decryption keys in ordinary database fields, source code, logs, analytics or admin tools.
- Use per-user vault keys and per-document data keys with a documented key-wrapping design.
- Provide key recovery through the user's recovery codes and a recovery flow requiring verified email plus an already-enrolled trusted contact.
- Recovery must include strong warnings, a waiting period, notifications to the user, rate limits and an audit trail.
- Support staff may view file metadata necessary for operations, such as encrypted object ID, size, type claim, upload date and security status, but not document contents or decrypted extracted text.
- Any AI document analysis must occur only after the user decrypts the file and gives explicit one-time consent. Send only the minimum required content through a protected server workflow, do not retain it by default, and explain that the selected AI processor temporarily receives the approved content.
- If the selected implementation cannot guarantee this privacy boundary, disable real document uploads and clearly mark the vault as a non-production prototype until the architecture passes independent security review.

Optional Google Drive encrypted backup may be designed later. Never expose an unencrypted vault folder in Drive.

## COMPLETE AI RETIREMENT PLANNER

Create an interactive planner with assumptions that users can edit:

- current age and target retirement age
- life expectancy planning age
- current monthly household spending
- retirement lifestyle level
- inflation
- current EPF, PRS, pension, cash and investment balances
- monthly contributions and expected employer contribution
- expected returns before and after retirement
- debts and expected payoff dates
- property values, rental income, vacancy, expenses and outstanding loans
- other retirement income, annuity/pension and part-time income
- dependants, education commitments and healthcare buffer
- desired legacy amount

Outputs:

- projected retirement fund
- estimated fund required at retirement
- monthly retirement income target
- projected shortfall or surplus
- required additional monthly saving
- estimated sustainable income range
- timeline and annual projection table
- conservative, expected and optimistic scenarios
- “retire earlier/later” comparison
- inflation-adjusted values
- property keep/sell/rent scenario modeller
- debt-first versus invest-first educational scenario
- downloadable retirement summary

Always show assumptions and calculation methodology. Avoid certainty, guaranteed returns or direct buy/sell recommendations. Include educational warnings that projections are estimates and professional advice may be appropriate.

## AI ADVISER

Create a conversational assistant named **Vitala Guide**. It can:

- explain the user’s dashboard in plain English or Bahasa Melayu
- extract structured fields from uploaded documents with consent
- identify missing documents or outdated records
- create an estate-readiness action list
- summarise insurance/takaful coverage facts
- run retirement scenarios
- detect apparent duplicated entries
- draft questions for a lawyer, hibah provider, insurer/takaful operator or financial planner
- generate a family emergency checklist
- create an annual review agenda
- explain general concepts without presenting legal or financial conclusions

AI safety:

- never invent balances, coverage, beneficiaries, legal validity or professional conclusions
- cite the user record or document used for each factual answer
- distinguish extracted facts, user-provided data, calculations and general education
- ask the user to confirm extracted data before saving
- obtain consent before reading a document
- do not send passwords or secret fields to the AI model
- allow opt-out and deletion of chat history
- escalate regulated, legal, tax or complex estate questions to a qualified professional

## CHROME EXTENSION COMPANION

Create a separate, later-phase Chrome extension companion using Manifest V3. Keep it optional and do not block the web-app MVP launch. The extension is a quick-capture and access companion, not a conventional password manager and not a full duplicate of the web application.

Permitted extension functions:

- secure Sign In that opens or completes authentication through the Vitala Amanah web app
- display a compact readiness summary and upcoming reminders
- quick-add an asset, policy, contact, reminder or digital-account reference
- save the current website as a reference linked to a user-selected record
- capture a receipt, policy page or account statement only after explicit user action and confirmation
- open the full web app at the relevant record
- show the pre-authorised Emergency Pack for the authenticated owner where appropriate
- lock automatically after inactivity
- detect a matched saved login locally and offer username/password autofill according to the user's per-website preference
- let the user configure each website as: ask before autofill, autofill after vault unlock, copy only, or never offer
- offer to save or update a login only after an explicit user action and clear item preview

Extension security requirements:

- request the minimum Chrome permissions; avoid broad `host_permissions` and never request browsing-history access
- operate only after an explicit user click; do not monitor browsing or scrape pages in the background
- never capture passwords silently, never capture seed phrases, never autofill on untrusted/mismatched origins, and never store raw secrets outside the unlocked encrypted vault context
- defend against lookalike domains and iframe-based credential capture; show the exact origin before reveal or autofill
- do not place access tokens or decrypted document content in ordinary `localStorage`; use short-lived sessions and protected extension storage appropriate to the architecture
- use a strict content security policy and prohibit remotely hosted executable code
- authenticate API calls and enforce the same server-side row-level permissions as the web app
- provide a visible lock state, Sign Out and Remove Local Data action
- clearly display what will be captured before saving and allow field editing
- include privacy disclosures suitable for Chrome Web Store review
- build and package the extension separately from the web app, with its own README, icons, screenshots checklist and store-submission checklist

## REMINDERS AND LIFE EVENTS

Support reminders for policy renewal, premium due date, document expiry, property taxes/fees, loan review, nomination review, will/hibah review, trusted-contact reconfirmation and annual vault review.

Life events: marriage, divorce/separation, birth/adoption, death of nominee/contact, property purchase/sale, new business, retirement, migration and major diagnosis. Each life event generates a review checklist but makes no automatic legal changes.

Notification policy:

- Include email and in-app notifications in every plan within reasonable limits.
- Let users enable or disable available channels by notification category.
- Do not include WhatsApp or SMS in the MVP subscription; prepare them as optional paid add-ons later.
- Allow optional monthly or quarterly safety check-ins.
- Missed check-ins create reminders and escalation according to the owner's settings, but do not automatically release the full vault.

## REPORTS AND EXPORTS

Generate user-selectable, watermarked PDFs:

- Personal Net-Worth Summary
- Asset and Liability Register
- Insurance/Takaful Summary
- Hibah and Nomination Checklist
- Legacy Readiness Report
- Family Emergency Pack
- Professional Meeting Pack
- Retirement Projection Report

PDF controls:

- let the user select which sections and records to include
- provide redacted and full-detail modes, with sensitive fields excluded by default
- require re-authentication before generating a full-detail report
- add a cover page, table of contents, generated date, owner, confidentiality notice and page numbers
- optionally password-protect the downloaded PDF using a password supplied at generation time; never store that PDF password
- generate PDFs on demand and delete temporary server copies automatically after a short expiry
- keep only report metadata by default, not a permanent duplicate PDF
- allow the user to save a generated report into their private vault only through an explicit action
- record report generation and download in the security audit history
- provide CSV export for structured asset, liability and policy tables
- provide a complete encrypted account backup in a documented portable format for migration or account closure
- before account closure provide redacted/full PDF options, CSV data tables, an archive of the user's original documents, a portable encrypted backup, and a final deletion certificate after deletion completes

Exports must allow redaction. Never include passwords or secret fields. Show generated date, owner name, confidentiality notice and disclaimer.

## STORAGE QUOTAS AND FILE LIFECYCLE

- Free: 100 MB total private document storage
- Pro: 2 GB total private document storage
- Family: 5 GB shared across the household and both adult vaults
- Additional storage add-on: 10 GB for RM5/month, subject to actual infrastructure cost review
- Show a storage meter and warnings at 75%, 90% and 100%
- Stop new uploads at the quota without blocking access to existing files
- Compress eligible images and scanned PDFs only when legibility is preserved
- Default individual upload limit: 20 MB; allow configurable higher limits for paid plans
- Use a 30-day recycle bin for paid users and 7 days for Free, subject to backup/deletion architecture
- Give users an explicit permanent-delete action with confirmation
- Deleted accounts enter a clearly stated recovery period before permanent deletion, except where immediate deletion is legally required
- After the recovery period, permanently delete active records and queued storage objects according to the published retention schedule, then issue a deletion certificate stating scope, request date and completion date without falsely claiming deletion from immutable backups before their normal expiry
- Generated PDFs are temporary unless the user deliberately saves them to the vault
- Storage calculations must include originals, retained versions, saved reports and recycle-bin items, and the UI must explain this

## PROFESSIONAL REFERRALS

Prepare a future-ready directory for verified estate lawyers, syariah/hibah specialists, licensed financial planners, insurance/takaful advisers, trustees, tax agents, accountants, company secretaries and property valuers.

MVP: display sample profiles marked “Demo” and a request-introduction flow. Do not fabricate licences, ratings or verification. Include disclosure for paid placements and referral fees.

Also provide a private “My Professionals” directory where users may add their own lawyer, hibah provider, insurance/takaful agent, financial planner, accountant, company secretary, property agent or other adviser without charge. These private contacts are never presented as Vitala-verified.

Public directory model:

- professionals apply and complete automated preliminary identity/credential checks followed by final admin approval
- paying a fee never creates verified status
- Basic listing: RM19.90/month; Featured listing: RM49.90/month; make prices configurable by admin
- profile includes approved credentials, service categories, locations, languages, contact preferences and required sponsorship/referral disclosure
- paid dashboard includes enquiries and basic analytics without exposing unrelated user data
- each professional chooses permitted contact methods: public phone, WhatsApp, email, callback request or private in-app enquiry
- founding-partner promotion may provide a configurable free trial without fake scarcity
- expired or unverified credentials trigger review and possible unpublishing

## SUBSCRIPTION EXPIRY AND INACTIVE ACCOUNTS

- Paid subscriptions receive a 30-day grace period after expiry or cancellation.
- During grace, allow normal access while showing payment and export reminders.
- After grace, switch the account to read-only: allow viewing, downloading, exporting, deleting and renewing, but block new uploads and records.
- Never delete excess paid-plan data immediately because the account downgraded.
- Archive inactive Free accounts after 12 months only after multiple email and in-app warnings.
- Define archive, restoration, retention and eventual deletion policies transparently; do not permanently delete solely because an account was archived without a further notice process.
- Stripe handles recurring subscriptions; ToyyibPay supports a time-limited access pass when recurring billing is unavailable. Verify both through server-side webhooks and an idempotent entitlement ledger.

## ADMIN PORTAL

Create role-protected admin screens for:

- user and subscription overview
- plan usage, storage and AI-credit monitoring
- payment and failed-payment status
- support requests and feedback
- professional partner applications and verification status
- referral tracking and disclosures
- feature flags
- content/disclaimer management
- security-event monitoring metadata without exposing decrypted user content
- deletion/export requests
- audit logs

Admins must not be able to casually browse private documents or secret fields.

## DATA MODEL

Design a relational schema for:

- users, profiles, households, household_members and subscriptions
- contacts, contact_roles and access_invitations
- assets, asset_owners, properties, accounts, investments, businesses, vehicles and valuables
- liabilities and guarantees
- policies, policy_people, coverage_benefits and claims_contacts
- hibah_records, nominations, legacy_documents and legacy_roles
- digital_accounts
- documents, document_versions, document_links and document_permissions
- access_rules, access_rule_approvers, emergency_requests and access_grants
- reminders and life_events
- retirement_profiles, retirement_assumptions, retirement_scenarios and projection_results
- AI_consents, AI_extractions and AI_messages
- audit_events, notifications, referrals and professional_profiles

Every sensitive record requires owner ID, household ID where relevant, created/updated timestamps, soft-deletion timestamp, data classification and permission checks. Use row-level access rules so users can access only records they own or that were explicitly shared with them.

## SECURITY ARCHITECTURE

Treat security as a product requirement, not a visual claim:

- use reputable managed authentication
- email verification, 2FA/passkeys and re-authentication for high-risk actions
- Argon2id or platform-managed password hashing; never custom cryptography
- TLS, secure cookies, CSRF protection, rate limiting and bot protection
- tenant isolation and deny-by-default authorisation
- row-level security or equivalent server-side enforcement
- field-level or envelope encryption for highly sensitive values
- managed key service with key rotation
- separate encryption context per user/household where feasible
- signed file URLs with short expiry
- virus scanning and file-type/size validation
- append-oriented security audit events
- secret management through environment variables
- no secrets or personal data in source control
- privacy-safe analytics
- backup, restore, breach-response and account-recovery plans
- test access-control boundaries
- PDPA-oriented consent, purpose limitation, access, correction, export and deletion workflows

True zero-knowledge encryption creates recovery and family-release trade-offs. Do not claim it unless a reviewed client-side key architecture exists. For the MVP, implement secure server-managed encryption and architect a future high-security client-encrypted vault tier.

## TECHNICAL IMPLEMENTATION

Use the standard stack supported by the selected Codex/Sites starter. Prefer TypeScript, reusable accessible components and server-side enforcement. For persistent production data, use an appropriate managed SQL database and private object storage supported by the platform. Use schema migrations and seed only obviously fictional demo data.

Requirements:

- functional responsive routes, forms, validation, CRUD and empty/loading/error states
- autosave where safe and explicit Save for sensitive changes
- confirmation dialogs for destructive or high-risk actions
- masked sensitive fields and “reveal” requiring re-authentication
- bilingual-ready translation files, not hard-coded duplicated pages
- no fake buttons
- no plaintext secrets
- no regulated claims
- no real payment charges until payment keys and webhook verification are configured
- payment adapter prepared for Stripe subscriptions and a Malaysian payment option later
- audit high-risk events such as export, share, reveal, download and access-rule changes
- automated tests for calculations, validation and permission boundaries

## REQUIRED PLATFORM SETUP AND DEPLOYMENT

The delivery is not complete with source code alone. Prepare and document the full production setup for **Supabase, a private GitHub repository and Vercel**. Never ask the user to paste secrets into chat, source files or screenshots. Use provider dashboards or secure environment-variable prompts for credentials.

### 1. Private GitHub repository

- initialise or connect one private GitHub repository for the application source
- include a clear `.gitignore` that excludes `.env`, `.env.local`, generated secrets, exports, local databases, uploaded files and decrypted test material
- commit application code, database migrations, seed scripts containing fictional data, tests, extension source and documentation
- never commit Supabase service-role keys, database passwords, Stripe/ToyyibPay secrets, AI keys, encryption material or real user data
- enable repository secret scanning and dependency/security alerts where available
- use protected `main` as the production branch and a separate development/preview workflow
- include pul