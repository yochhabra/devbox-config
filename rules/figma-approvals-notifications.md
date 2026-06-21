# Figma Approvals Platform Notification Pages

Use this guide when creating or updating Figma pages that visualize Slack notifications from the Approvals Platform.

## Figma File
- File key: `56eTYhrLm088Q6TUKXxlIq`
- Bot avatar image: stored as hidden node "output 1" on page 1 — read its `fills` to reuse on all Bot Avatar rectangles

## Page Structure (top to bottom, 30px gaps)
1. **Title bar** — purple (`r:.28,g:.12,b:.42`), 55px tall, rounded 10px
2. **Flow Legend** — dark gray (`r:.17,g:.17,b:.2`), 38px tall, step labels with `→` arrows between them. Use "Waiting on {name}" not "Waiting→{name}"
3. **Reading Guide** — dark gray with purple border, 70px tall. Yellow header "How to read this page", explains that numbered badges and purple labels are annotations, not part of actual notifications
4. **Slack Windows** — side by side, one per user who receives notifications

## Dark Mode Color Palette
```
Page background:     r:.09, g:.09, b:.11
Window/message bg:   r:.13, g:.13, b:.15
Window header:       r:.1,  g:.06, b:.13
Dividers:            r:.25, g:.25, b:.28
Primary text:        r:.9,  g:.9,  b:.92
Secondary text:      r:.55, g:.55, b:.6
White:               r:1,   g:1,   b:1
Link blue:           r:.35, g:.66, b:.96
Purple (labels):     r:.65, g:.5,  b:.92
APP tag bg:          r:.25, g:.18, b:.35
Step badge bg:       r:.36, g:.36, b:.4
Red (notif count):   r:.88, g:.24, b:.3
Note bg:             r:.17, g:.17, b:.2
Note border:         r:.35, g:.3,  b:.5
Yellow (guide title): r:1,  g:.85, b:.35
```

## Slack Message Block Layout
Each message frame uses absolute positioning, NOT auto-layout (auto-layout causes height collapse issues in Figma Plugin API).

```
Constants:
  IX=12, IY=33         Bot avatar position (left column)
  IW=36                Bot avatar size (36x36, cornerRadius=8)
  CX=58                Content X start (right of avatar)
  SP=32                Line spacing between elements

Message structure (Y positions from IY):
  y=6:    Step badge (22x22 circle) + purple event label (annotation only)
  y=IY:   [Bot Avatar 36x36]  |  ApprovalsBot (15px Bold) + APP tag + timestamp
  +SP:                         |  Deal Pricing | Acme Corp Renewal (15px Bold, white)
  +SP:                         |  Message body text (15px Regular, white, auto-height)
  +SP:                         |  [Optional] Blockquote bar (3px wide, 19px tall, white) + quote text
  +14:                         |  View in APEX (14px Semi Bold, blue, underlined)
  bottom:  Divider line (1px)
```

## Blockquote Rendering
Templates with reason blocks use Slack mrkdwn `>` which renders as a left bar + indented text:
- Bar: 3px wide, 19px tall, white color (`r:.9,g:.9,b:.92`), cornerRadius=1
- Text: 12px right of bar, vertically centered with bar, white color, 15px Regular
- Admin override reasons prefixed with `[Admin override]`

## Dynamic Height Handling
- Measure message text length: >70 chars adds 20px extra for line wrap
- Position "View in APEX" link relative to actual content bottom, not fixed Y
- After creating all messages, reposition sequentially and resize window to fit

## Window Structure
```
Window: 720px wide, rounded 12px, 1px border
  Header (60px): dark purple bg, user avatar (36px ellipse), name + role, red notification count badge
  Messages area: 16px top padding, 6px gap between messages, 16px bottom padding
```

## Notification Templates Reference
Source: `zoolander/src/java/com/stripe/approvals_platform/approvalsplatform/lib/notifications/templates/`

### Bot identity
- Name: "ApprovalsBot" (with APP tag)
- Header block: "Deal Pricing | Acme Corp Renewal" (bold white, represents rule | subject from CommonBlocksProvider)

### Message templates by event type

**ApprovalCreated → Requestor:**
"Your approval request has been created."

**SelfApproved → Requestor:**
"The approval request was successfully self-approved!"

**WaitingOnApprover → Requestor:**
"Your approval request needs to be approved by @{approver} ({nodeTitle})."

**WaitingOnApprover → Approver:**
"@{requestor} is requesting your approval on an approval request."

**NodeApproved → Requestor:**
"Your approval request was approved by @{approver} ({nodeTitle})."
+ optional reason blockquote

**NodeApproved → Approver:**
"You have successfully approved the approval request!"
+ optional reason blockquote

**NodeDenied → Requestor:**
"Your approval request was denied by @{approver} ({nodeTitle})."
+ optional reason blockquote

**NodeDenied → Approver:**
"You have denied the approval request."
+ optional reason blockquote

**SentBackToRequestor → Requestor:**
"The approval request was sent back to you by @{approver} ({nodeTitle})."
+ reason blockquote

**SentBackToRequestor → Approver:**
"The approval request was sent back to requestor."
+ reason blockquote

**AdminApproved → Requestor:**
"Your approval request was approved via admin override by @{admin} ({nodeTitle})."
+ blockquote: "[Admin override] {reason}"

**AdminApproved → Approver:**
"The approval request assigned to you was approved via admin override by @{admin} ({nodeTitle})."
+ blockquote: "[Admin override] {reason}"

**AdminApproved → Admin:**
"You have approved the approval request via admin override ({nodeTitle})."
+ blockquote: "[Admin override] {reason}"

**ApprovalCompleted → Requestor:**
"Your approval request was approved by the final approver."

**Cancelled → Participant (approver):**
"The approval request was cancelled."

**Cancelled → Requestor (via ApprovalCompleted):**
"The approval request was cancelled."

**CommentAdded → Participants (requestor + current approvers):**
"A new comment was added by @{commenter} :"
+ blockquote: "{comment body}"

### Resolver logic (who gets notified)
- **ApprovalCreated**: requestor only
- **SelfApproved**: requestor only
- **WaitingOnApprover**: requestor + currentApprover
- **NodeApproved**: requestor + currentApprover
- **NodeDenied**: requestor + currentApprover
- **SentBack**: requestor + currentApprover
- **AdminApproved**: requestor + currentApprover + admin (per node)
- **Cancelled**: currentApprover only (requestor gets it via ApprovalCompleted)
- **ApprovalCompleted**: requestor only
- **CommentAdded**: requestor + all currentApprovers (deduped)

## Existing Pages
1. Approval Approved and completed — happy path (frodo, aragorn, gandalf)
2. Approval Denied — aragorn denies (frodo, aragorn)
3. Sent Back to Requestor — sent back with reason, resubmitted (frodo, aragorn)
4. Admin Override Approved — Elrond overrides all nodes (frodo, aragorn, gandalf, Elrond)
5. Cancelled — requestor cancels (frodo, aragorn)
6. Comment Added — gimli comments (frodo, aragorn)

## Characters
- Requestor: frodo (Frodo Baggins)
- First approver: aragorn (Legal Review)
- Second/final approver: gandalf (Deal Pricing Review)
- Admin: Elrond
- Viewer/commenter: gimli

## Common Pitfalls
- Auto-layout causes frame height collapse — use absolute positioning
- Bot avatar image fills get lost when rebuilding — always re-read from "output 1" node on page 1
- Pages 2+ content can disappear — verify with `get_metadata` before modifying, rebuild if empty
- `use_figma` font errors — always load Inter Regular, Semi Bold, and Bold before any text operations
- Set `page.backgrounds` for dark mode — frame fills alone leave white canvas
