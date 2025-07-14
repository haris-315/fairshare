// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'comment_page.dart';
// import '../bloc/group_bloc.dart';
// import '../bloc/group_event.dart';
// import '../bloc/group_state.dart';

// class GroupDashboardPage extends StatefulWidget {
//   final String groupId;

//   const GroupDashboardPage({required this.groupId});

//   @override
//   _GroupDashboardPageState createState() => _GroupDashboardPageState();
// }

// class _GroupDashboardPageState extends State<GroupDashboardPage> {
//   final _memberEmailController = TextEditingController();
//   final _expenseAmountController = TextEditingController();
//   final _expenseDescriptionController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     context.read<GroupBloc>().add(LoadGroupDetailsEvent(groupId: widget.groupId));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Group Dashboard')),
//       body: BlocConsumer<GroupBloc, GroupState>(
//         listener: (context, state) {
//           if (state is GroupError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is GroupLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is GroupDetailsLoaded) {
//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Group: ${state.group.name}', style: Theme.of(context).textTheme.headline6),
//                   const SizedBox(height: 20),
//                   Text('Members:', style: Theme.of(context).textTheme.subtitle1),
//                   StreamBuilder(
//                     stream: Supabase.instance.client
//                         .from('group_members')
//                         .stream(primaryKey: ['group_id', 'user_id'])
//                         .eq('group_id', widget.groupId),
//                     builder: (context, snapshot) {
//                       if (!snapshot.hasData) {
//                         return const Center(child: CircularProgressIndicator());
//                       }
//                       final members = snapshot.data as List<Map<String, dynamic>>;
//                       return ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: members.length,
//                         itemBuilder: (context, index) {
//                           return ListTile(
//                             title: FutureBuilder(
//                               future: Supabase.instance.client
//                                   .from('users')
//                                   .select('username')
//                                   .eq('id', members[index]['user_id'])
//                                   .single(),
//                               builder: (context, snapshot) {
//                                 return Text(snapshot.hasData ? snapshot.data!['username'] : 'Loading...');
//                               },
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: _memberEmailController,
//                     decoration: const InputDecoration(labelText: 'Add Member (User ID)'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       final userId = _memberEmailController.text;
//                       if (userId.isNotEmpty) {
//                         context.read<GroupBloc>().add(AddMemberEvent(
//                               groupId: widget.groupId,
//                               userId: userId,
//                             ));
//                         _memberEmailController.clear();
//                       }
//                     },
//                     child: const Text('Add Member'),
//                   ),
//                   const SizedBox(height: 20),
//                   Text('Expenses:', style: Theme.of(context).textTheme.subtitle1),
//                   StreamBuilder(
//                     stream: Supabase.instance.client
//                         .from('expenses')
//                         .stream(primaryKey: ['id'])
//                         .eq('group_id', widget.groupId),
//                     builder: (context, snapshot) {
//                       if (!snapshot.hasData) {
//                         return const Center(child: CircularProgressIndicator());
//                       }
//                       final expenses = snapshot.data as List<Map<String, dynamic>>;
//                       return ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: expenses.length,
//                         itemBuilder: (context, index) {
//                           final expense = expenses[index];
//                           return ListTile(
//                             title: Text('\$${expense['amount']} - ${expense['description']}'),
//                             subtitle: Text(DateTime.parse(expense['created_at']).toLocal().toString()),
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => CommentPage(expenseId: expense['id']),
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: _expenseAmountController,
//                     decoration: const InputDecoration(labelText: 'Expense Amount'),
//                     keyboardType: TextInputType.number,
//                   ),
//                   TextField(
//                     controller: _expenseDescriptionController,
//                     decoration: const InputDecoration(labelText: 'Expense Description'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       final amount = double.tryParse(_expenseAmountController.text);
//                       if (amount != null && _expenseDescriptionController.text.isNotEmpty) {
//                         context.read<GroupBloc>().add(AddExpenseEvent(
//                               groupId: widget.groupId,
//                               userId: Supabase.instance.client.auth.currentUser!.id,
//                               amount: amount,
//                               description: _expenseDescriptionController.text,
//                             ));
//                         _expenseAmountController.clear();
//                         _expenseDescriptionController.clear();
//                       }
//                     },
//                     child: const Text('Add Expense'),
//                   ),
//                 ],
//               ),
//             );
//           }
//           return const Center(child: Text('No group details found'));
//         },
//       ),
//     );
//   }
// }
