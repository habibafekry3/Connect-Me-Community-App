
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectme_app/Presentation/blocs/profile_cubit.dart';
import 'package:connectme_app/Presentation/blocs/profile_state.dart';
import 'package:connectme_app/data/models/user_model_builder.dart';
import 'package:connectme_app/injection.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<Map<String, String>> _getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      return {
        'Device': info.model,
        'System': 'Android ${info.version.release}',
      };
    }

    if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      return {
        'Device': info.utsname.machine,
        'System': 'iOS ${info.systemVersion}',
      };
    }

    return {
      'Device': 'Unknown',
      'System': Platform.operatingSystem,
    };
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(
          child: Text('Please log in to view your profile.'),
        ),
      );
    }

    final user = UserModelBuilder()
        .setId(firebaseUser.uid)
        .setFullName(firebaseUser.displayName ?? 'User')
        .setEmail(firebaseUser.email ?? '')
        .setPhotoUrl(firebaseUser.photoURL)
        .build();

    return BlocProvider(
      create: (_) => getIt<ProfileCubit>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: const Text('My Profile')),
            body: BlocListener<ProfileCubit, ProfileState>(
              listenWhen: (previous, current) =>
                  previous.successMessage != current.successMessage ||
                  previous.errorMessage != current.errorMessage,
              listener: (context, state) {
                if (state.successMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile photo saved successfully!'),
                    ),
                  );
                }

                if (state.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Failed to save photo: ${state.errorMessage}',
                      ),
                    ),
                  );
                }
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      StreamBuilder<
                          DocumentSnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(firebaseUser.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          final encodedImage = snapshot.data
                              ?.data()?['profileImageBase64'] as String?;

                          ImageProvider? image;

                          if (encodedImage != null &&
                              encodedImage.isNotEmpty) {
                            try {
                              image = MemoryImage(
                                base64Decode(encodedImage),
                              );
                            } catch (e) {
                              debugPrint('Profile image decode error: $e');
                            }
                          }

                          return CircleAvatar(
                            radius: 50,
                            backgroundImage: image,
                            child: image == null
                                ? const Icon(Icons.person, size: 50)
                                : null,
                          );
                        },
                      ),

                      const SizedBox(height: 12),

                      BlocBuilder<ProfileCubit, ProfileState>(
                        builder: (context, state) {
                          return Column(
                            children: [
                              if (state.isLoading) ...[
                                const CircularProgressIndicator(),
                                const SizedBox(height: 8),
                                const Text('Saving profile photo...'),
                              ],
                              TextButton.icon(
                                onPressed: state.isLoading
                                    ? null
                                    : () => context
                                        .read<ProfileCubit>()
                                        .pickAndUploadPhoto(),
                                icon: const Icon(
                                  Icons.photo_library_outlined,
                                ),
                                label: const Text('Choose Profile Photo'),
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      Text(
                        user.fullName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(user.email),
                      const SizedBox(height: 24),

                      const Text(
                        'Device Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      FutureBuilder<Map<String, String>>(
                        future: _getDeviceInfo(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          if (snapshot.hasError) {
                            return const Text(
                              'Unable to load device information.',
                            );
                          }

                          if (!snapshot.hasData) {
                            return const Text(
                              'No device information available.',
                            );
                          }

                          final info = snapshot.data!;

                          return Column(
                            children: [
                              Text('Device: ${info['Device']}'),
                              const SizedBox(height: 8),
                              Text('System: ${info['System']}'),
                            ],
                          );
                        },
                      ),


                      
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
