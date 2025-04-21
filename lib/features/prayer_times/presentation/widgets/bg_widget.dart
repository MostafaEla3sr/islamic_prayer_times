import 'package:flutter/material.dart';
import 'package:islamic_prayer_times/core/extentions/glopal_extentions.dart';
import 'package:islamic_prayer_times/core/utils/styles.dart';
import 'package:islamic_prayer_times/generated/assets.dart';

import 'prayer_times_list.dart';

class BgWidget extends StatelessWidget {
  const BgWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.imagesBackground,
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      fit: BoxFit.cover,
    );
  }
}
