import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:mobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:mobile/features/auth/presentation/screens/phone_input_screen.dart';
import 'package:mobile/main_tab_scaffold.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthStatusCheckEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitialState) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is AuthenticatedState) {
          return const MainTabScaffold();
        }

        if (state is AuthUnauthenticatedState) {
          return const PhoneInputScreen();
        }

        return const Scaffold(body: Center(child: Text("Unknown auth state")));
      },
    );
  }
}
