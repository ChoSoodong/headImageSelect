# headImageSelect
头像选择
[SDAvatarPicker avatarSelected:^(UIImage * _Nonnull image) {
        if (image) {
            [sender setImage:image forState:UIControlStateNormal];
        }
    }];
