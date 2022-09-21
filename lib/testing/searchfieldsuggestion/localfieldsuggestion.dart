import 'package:flutter/material.dart';
import 'package:flutter_crud/testing/searchfieldsuggestion/user_api.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class LocalTypeAheadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(16),
            child: TypeAheadField<Useri?>(
              hideSuggestionsOnKeyboardHide: false,
              textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  hintText: 'Search Username',
                ),
              ),
              suggestionsCallback: UserData.getSuggestions,
              itemBuilder: (context, Useri? suggestion) {
                final user = suggestion!;

                return ListTile(
                  leading: Container(
                    width: 60,
                    height: 60,
                    child: Image.network(
                      user.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(user.name),
                );
              },
              noItemsFoundBuilder: (context) => Container(
                height: 100,
                child: Center(
                  child: Text(
                    'No Users Found.',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              onSuggestionSelected: (Useri? suggestion) {
                final user = suggestion!;

                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UserDetailPage(user: user),
                ));
              },
            ),
          ),
        ),
      );
}

class UserDetailPage extends StatelessWidget {
  final Useri user;

  const UserDetailPage({
    required this.user,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(user.name),
        ),
        body: ListView(
          children: [
            Image.network(
              user.imageUrl,
              height: 300,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              user.name,
              style: TextStyle(fontSize: 28),
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
}
