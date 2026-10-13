import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'setting_screen.dart';
import 'splash_screen.dart';

class HomeScreen extends StatefulWidget {
const HomeScreen({super.key});

@override
State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
int _currentIndex = 0;

List<Widget> _getPages() {
return const [
NotesGridView(),
BookmarksView(),
NotificationsView(),
SettingsScreen(),
];
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xFFE5ECE9),

  drawer: Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        // Dynamic User Header
        UserAccountsDrawerHeader(
          decoration: const BoxDecoration(
            color: Color(0xFFE07A5F),
          ),
          accountName: const Text(
            'My Notes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          accountEmail: Text(
            FirebaseAuth.instance.currentUser?.email ?? 'User Email',
            style: const TextStyle(color: Colors.white70),
          ),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 40,
              color: const Color(0xFFE07A5F),
            ),
          ),
        ),

        // Menu Item 1: All Notes
        ListTile(
          leading: const Icon(Icons.notes),
          title: const Text('All Notes'),
          onTap: () {
            Navigator.pop(context); // Drawer close karne ke liye
            setState(() {
              _currentIndex = 0; // Notes View par switch karega
            });
          },
        ),

        // Divider Line
        const Divider(),

        // Menu Item 2: Logout Button
        ListTile(
          leading: const Icon(
            Icons.logout,
            color: Colors.redAccent,
          ),
          title: const Text(
            'Logout',
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
          onTap: () async {
            // Firebase sign out
            await FirebaseAuth.instance.signOut();

            if (context.mounted) {
              // Wapas Login Screen par bhej dega
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                    (route) => false,
              );
            }
          },
        ),
      ],
    ),
  ),

appBar: AppBar(
backgroundColor: Colors.transparent,
elevation: 0,
centerTitle: true,
iconTheme: const IconThemeData(
color: Colors.black87,
),
title: Text(
_getAppBarTitle(_currentIndex),
style: const TextStyle(
color: Colors.black87,
fontSize: 26,
fontWeight: FontWeight.w500,
),
),
),

body: IndexedStack(
index: _currentIndex,
children: _getPages(),
),

floatingActionButtonLocation:
FloatingActionButtonLocation.centerDocked,

floatingActionButton: FloatingActionButton(
elevation: 2,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(16),
),
backgroundColor: const Color(0xFFE07A5F),
onPressed: () {
if (_currentIndex != 0) {
setState(() {
_currentIndex = 0;
});
}

_showNoteDialog(context);
},
child: const Icon(
Icons.add,
color: Colors.white,
size: 28,
),
),

bottomNavigationBar: BottomAppBar(
shape: const CircularNotchedRectangle(),
notchMargin: 8.0,
color: Colors.white.withOpacity(0.95),
child: SizedBox(
height: 60,
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceAround,
children: [
IconButton(
tooltip: 'Notes',
icon: Icon(
Icons.grid_view_rounded,
color: _currentIndex == 0
? const Color(0xFFE07A5F)
    : Colors.grey,
size: 26,
),
onPressed: () {
setState(() {
_currentIndex = 0;
});
},
),

IconButton(
tooltip: 'Bookmarks',
icon: Icon(
_currentIndex == 1
? Icons.bookmark_rounded
    : Icons.bookmark_border_rounded,
color: _currentIndex == 1
? const Color(0xFFE07A5F)
    : Colors.grey,
size: 26,
),
onPressed: () {
setState(() {
_currentIndex = 1;
});
},
),

const SizedBox(width: 40),

IconButton(
tooltip: 'Notifications',
icon: Icon(
_currentIndex == 2
? Icons.notifications_rounded
    : Icons.notifications_none_rounded,
color: _currentIndex == 2
? const Color(0xFFE07A5F)
    : Colors.grey,
size: 26,
),
onPressed: () {
setState(() {
_currentIndex = 2;
});
},
),

IconButton(
tooltip: 'Settings',
icon: Icon(
_currentIndex == 3
? Icons.settings_rounded
    : Icons.settings_outlined,
color: _currentIndex == 3
? const Color(0xFFE07A5F)
    : Colors.grey,
size: 26,
),
onPressed: () {
setState(() {
_currentIndex = 3;
});
},
),
],
),
),
),
);
}

String _getAppBarTitle(int index) {
switch (index) {
case 0:
return 'My notes...';
case 1:
return 'Bookmarks';
case 2:
return 'Notifications';
case 3:
return 'Settings';
default:
return 'My notes...';
}
}

void _showNoteDialog(
BuildContext context, {
DocumentSnapshot? doc,
}) {
final Map<String, dynamic>? data =
doc?.data() as Map<String, dynamic>?;

final titleController = TextEditingController(
text: data?['title']?.toString() ?? '',
);

final contentController = TextEditingController(
text: data?['content']?.toString() ?? '',
);

// TWO NEW FIELD CONTROLLERS
final categoryController = TextEditingController(
text: data?['category']?.toString() ?? '',
);

final priorityController = TextEditingController(
text: data?['priority']?.toString() ?? '',
);

showDialog(
context: context,
builder: (dialogContext) {
return AlertDialog(
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(16),
),
title: Text(
doc == null ? 'Add Note' : 'Edit Note',
style: const TextStyle(
fontWeight: FontWeight.bold,
),
),

content: SingleChildScrollView(
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
TextField(
controller: titleController,
decoration: const InputDecoration(
labelText: 'Title',
border: OutlineInputBorder(),
),
),

const SizedBox(height: 12),

TextField(
controller: contentController,
decoration: const InputDecoration(
labelText: 'Content',
border: OutlineInputBorder(),
),
maxLines: 3,
),

const SizedBox(height: 12),

// NEW FIELD 1: Category
TextField(
controller: categoryController,
decoration: const InputDecoration(
labelText: 'Category (e.g., Work, Personal)',
border: OutlineInputBorder(),
),
),

const SizedBox(height: 12),

// NEW FIELD 2: Priority
TextField(
controller: priorityController,
decoration: const InputDecoration(
labelText: 'Priority (e.g., High, Low)',
border: OutlineInputBorder(),
),
),
],
),
),

actions: [
TextButton(
onPressed: () {
Navigator.pop(dialogContext);
},
child: const Text('Cancel'),
),

ElevatedButton(
style: ElevatedButton.styleFrom(
backgroundColor: const Color(0xFFE07A5F),
foregroundColor: Colors.white,
),

onPressed: () async {
final title = titleController.text.trim();
final content = contentController.text.trim();
final category = categoryController.text.trim();
final priority = priorityController.text.trim();

if (title.isEmpty) {
return;
}

final collection =
FirebaseFirestore.instance.collection('notes');

try {
if (doc == null) {
// ADD QUERY WITH TWO NEW FIELDS
await collection.add({
'title': title,
'content': content,
'category': category,
'priority': priority,
'isBookmarked': false,
'timestamp': FieldValue.serverTimestamp(),
});
} else {
// UPDATE QUERY WITH TWO NEW FIELDS
await collection.doc(doc.id).update({
'title': title,
'content': content,
'category': category,
'priority': priority,
});
}

if (dialogContext.mounted) {
Navigator.pop(dialogContext);
}
} catch (e) {
if (dialogContext.mounted) {
ScaffoldMessenger.of(dialogContext).showSnackBar(
SnackBar(
content: Text('Error: $e'),
),
);
}
}
},

child: const Text('Save'),
),
],
);
},
);
}
}

// ============================================================
// NOTES GRID VIEW
// ============================================================
class NotesGridView extends StatefulWidget {
const NotesGridView({super.key});

@override
State<NotesGridView> createState() => _NotesGridViewState();
}

class _NotesGridViewState extends State<NotesGridView> {
final CollectionReference<Map<String, dynamic>> _notesCollection =
FirebaseFirestore.instance.collection('notes');

String _searchQuery = '';

final TextEditingController _searchController =
TextEditingController();

// ================= DELETE NOTE =================

Future<void> _deleteNote(String id) async {
try {
await _notesCollection.doc(id).delete();

if (mounted) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('Note deleted successfully'),
),
);
}
} catch (e) {
if (mounted) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text('Delete error: $e'),
),
);
}
}
}

// ================= BOOKMARK =================

Future<void> _toggleBookmark(
String id,
bool currentStatus,
) async {
try {
await _notesCollection.doc(id).update({
'isBookmarked': !currentStatus,
});
} catch (e) {
if (mounted) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text('Bookmark error: $e'),
),
);
}
}
}

// ================= EDIT NOTE =================

void _showEditNoteDialog(
DocumentSnapshot<Map<String, dynamic>> doc,
) {
final data = doc.data();

final titleController = TextEditingController(
text: data?['title']?.toString() ?? '',
);

final contentController = TextEditingController(
text: data?['content']?.toString() ?? '',
);

final categoryController = TextEditingController(
text: data?['category']?.toString() ?? '',
);

final priorityController = TextEditingController(
text: data?['priority']?.toString() ?? '',
);

showDialog(
context: context,
builder: (dialogContext) {
return AlertDialog(
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(16),
),

title: const Text(
'Note Details',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),

content: SingleChildScrollView(
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
TextField(
controller: titleController,
decoration: const InputDecoration(
labelText: 'Title',
hintText: 'Enter note title',
border: OutlineInputBorder(),
),
),

const SizedBox(height: 12),

TextField(
controller: contentController,
decoration: const InputDecoration(
labelText: 'Content',
hintText: 'Enter note content',
border: OutlineInputBorder(),
),
maxLines: 4,
),

const SizedBox(height: 12),

// NEW FIELD 1 IN EDIT
TextField(
controller: categoryController,
decoration: const InputDecoration(
labelText: 'Category',
border: OutlineInputBorder(),
),
),

const SizedBox(height: 12),

// NEW FIELD 2 IN EDIT
TextField(
controller: priorityController,
decoration: const InputDecoration(
labelText: 'Priority',
border: OutlineInputBorder(),
),
),
],
),
),

actions: [
TextButton(
onPressed: () {
Navigator.pop(dialogContext);
},
child: const Text('Cancel'),
),

ElevatedButton(
style: ElevatedButton.styleFrom(
backgroundColor: const Color(0xFFE07A5F),
foregroundColor: Colors.white,
),

onPressed: () async {
final title = titleController.text.trim();
final content = contentController.text.trim();
final category = categoryController.text.trim();
final priority = priorityController.text.trim();

if (title.isEmpty) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('Please enter a title'),
),
);
return;
}

try {
// UPDATE QUERY WITH TWO NEW FIELDS
await _notesCollection.doc(doc.id).update({
'title': title,
'content': content,
'category': category,
'priority': priority,
});

if (dialogContext.mounted) {
Navigator.pop(dialogContext);
}

if (mounted) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('Note updated successfully'),
),
);
}
} catch (e) {
if (mounted) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text('Update error: $e'),
),
);
}
}
},

child: const Text('Update'),
),
],
);
},
);
}

// ================= DISPOSE =================

@override
void dispose() {
_searchController.dispose();
super.dispose();
}

// ================= BUILD =================

@override
Widget build(BuildContext context) {
return Column(
children: [
// ================= SEARCH BAR =================

Padding(
padding: const EdgeInsets.symmetric(
horizontal: 20,
vertical: 8,
),

child: Container(
decoration: BoxDecoration(
color: Colors.white.withOpacity(0.7),
borderRadius: BorderRadius.circular(30),
),

child: TextField(
controller: _searchController,

onChanged: (value) {
setState(() {
_searchQuery = value.toLowerCase();
});
},

decoration: const InputDecoration(
hintText: 'Search notes...',

hintStyle: TextStyle(
color: Colors.black38,
),

prefixIcon: Icon(
Icons.search,
color: Colors.black38,
),

border: InputBorder.none,

contentPadding: EdgeInsets.symmetric(
vertical: 14,
),
),
),
),
),

// ================= NOTES GRID =================

Expanded(
child: StreamBuilder<
QuerySnapshot<Map<String, dynamic>>>(
stream: _notesCollection
    .orderBy(
'timestamp',
descending: true,
)
    .snapshots(),

builder: (context, snapshot) {
if (snapshot.hasError) {
return Center(
child: Text(
'Something went wrong:\n${snapshot.error}',
textAlign: TextAlign.center,
),
);
}

if (snapshot.connectionState ==
ConnectionState.waiting) {
return const Center(
child: CircularProgressIndicator(),
);
}

final docs = snapshot.data?.docs ?? [];

// ================= SEARCH FILTER =================

final filteredDocs = docs.where((doc) {
final data = doc.data();

final title = data['title']?.toString().toLowerCase() ?? '';
final content = data['content']?.toString().toLowerCase() ?? '';
final category = data['category']?.toString().toLowerCase() ?? '';

return title.contains(_searchQuery) ||
content.contains(_searchQuery) ||
category.contains(_searchQuery);
}).toList();

if (filteredDocs.isEmpty) {
return const Center(
child: Text(
'Koi notes nahi hain.',
style: TextStyle(
color: Colors.grey,
),
),
);
}

// ================= GRID =================

return GridView.builder(
padding: const EdgeInsets.all(16),

gridDelegate:
const SliverGridDelegateWithFixedCrossAxisCount(
crossAxisCount: 2,
crossAxisSpacing: 12,
mainAxisSpacing: 12,
childAspectRatio: 0.75,
),

itemCount: filteredDocs.length,

itemBuilder: (context, index) {
final note = filteredDocs[index];
final data = note.data();

final title = data['title']?.toString() ?? 'Untitled';
final content = data['content']?.toString() ?? '';
final category = data['category']?.toString() ?? '';
final priority = data['priority']?.toString() ?? '';
final isBookmarked = data['isBookmarked'] as bool? ?? false;

return Container(
padding: const EdgeInsets.all(14),

decoration: BoxDecoration(
color: index % 2 == 0
? const Color(0xFFF3C6BD)
    : const Color(0xFFEAD29A),

borderRadius: BorderRadius.circular(20),
),

child: Column(
crossAxisAlignment: CrossAxisAlignment.start,

children: [
// TITLE + MENU
Row(
children: [
Expanded(
child: Text(
title,
style: const TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
),
overflow: TextOverflow.ellipsis,
),
),

PopupMenuButton<String>(
icon: const Icon(
Icons.more_vert,
size: 18,
),

onSelected: (value) {
if (value == 'edit') {
_showEditNoteDialog(note);
}
if (value == 'delete') {
_deleteNote(note.id);
}
if (value == 'bookmark') {
_toggleBookmark(note.id, isBookmarked);
}
},

itemBuilder: (context) => [
const PopupMenuItem(
value: 'edit',
child: Text('Edit'),
),
const PopupMenuItem(
value: 'delete',
child: Text('Delete'),
),
PopupMenuItem(
value: 'bookmark',
child: Text(
isBookmarked ? 'Unbookmark' : 'Bookmark',
),
),
],
),
],
),

// NEW FIELD DISPLAY: Category Chip
if (category.isNotEmpty)
Container(
margin: const EdgeInsets.only(bottom: 6),
padding: const EdgeInsets.symmetric(
horizontal: 8, vertical: 2),
decoration: BoxDecoration(
color: Colors.white.withOpacity(0.6),
borderRadius: BorderRadius.circular(10),
),
child: Text(
category,
style: const TextStyle(
fontSize: 10,
fontWeight: FontWeight.bold,
),
),
),

// CONTENT
Expanded(
child: Text(
content,
maxLines: 3,
overflow: TextOverflow.ellipsis,
style: const TextStyle(
color: Colors.black87,
fontSize: 12,
),
),
),

// NEW FIELD DISPLAY: Priority
if (priority.isNotEmpty)
Align(
alignment: Alignment.bottomRight,
child: Text(
'Priority: $priority',
style: const TextStyle(
fontSize: 10,
fontStyle: FontStyle.italic,
color: Colors.black54,
),
),
),

const SizedBox(height: 8),

// DETAILS BUTTON
SizedBox(
width: double.infinity,
height: 34,
child: ElevatedButton(
onPressed: () {
_showEditNoteDialog(note);
},
style: ElevatedButton.styleFrom(
backgroundColor: const Color(0xFFE07A5F),
foregroundColor: Colors.white,
padding: EdgeInsets.zero,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(10),
),
),
child: const Text(
'Details',
style: TextStyle(fontSize: 12),
),
),
),
],
),
);
},
);
},
),
),
],
);
}
}



// ============================================================
// BOOKMARKS VIEW
// ============================================================

class BookmarksView extends StatelessWidget {
const BookmarksView({super.key});

@override
Widget build(BuildContext context) {
final notesCollection =
FirebaseFirestore.instance.collection('notes');

return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
stream: notesCollection
    .where(
'isBookmarked',
isEqualTo: true,
)
    .snapshots(),

builder: (context, snapshot) {
if (snapshot.hasError) {
return Center(
child: Text(
'Error loading bookmarks:\n${snapshot.error}',
textAlign: TextAlign.center,
),
);
}

if (snapshot.connectionState == ConnectionState.waiting) {
return const Center(
child: CircularProgressIndicator(),
);
}

final docs = snapshot.data?.docs ?? [];

if (docs.isEmpty) {
return const Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(
Icons.bookmark_border,
size: 60,
color: Colors.grey,
),
SizedBox(height: 12),
Text(
'Koi bookmarked notes nahi hain.',
style: TextStyle(
color: Colors.grey,
fontSize: 16,
),
),
],
),
);
}

return ListView.builder(
padding: const EdgeInsets.all(16),
itemCount: docs.length,

itemBuilder: (context, index) {
final data = docs[index].data();

return Card(
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),

margin: const EdgeInsets.only(
bottom: 12,
),

child: ListTile(
leading: const Icon(
Icons.bookmark,
color: Color(0xFFE07A5F),
),

title: Text(
data['title']?.toString() ?? 'Untitled',
style: const TextStyle(
fontWeight: FontWeight.bold,
),
),

subtitle: Text(
data['content']?.toString() ?? '',
maxLines: 2,
overflow: TextOverflow.ellipsis,
),
),
);
},
);
},
);
}
}

// ============================================================
// NOTIFICATIONS VIEW
// ============================================================

class NotificationsView extends StatelessWidget {
const NotificationsView({super.key});

@override
Widget build(BuildContext context) {
return const Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(
Icons.notifications_none_rounded,
size: 60,
color: Colors.grey,
),

SizedBox(height: 12),

Text(
'Koi nai notifications nahi hain.',
style: TextStyle(
color: Colors.grey,
fontSize: 16,
),
),
],
),
);
}
}