import React from 'react';
import { TouchableOpacity, Text, StyleSheet, View } from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { COLORS } from '../../utils/constants';

const ContactButton = ({ icon, label, onPress }) => {
  return (
    <TouchableOpacity style={styles.button} onPress={onPress} activeOpacity={0.8}>
      <View style={styles.iconContainer}>
        <MaterialIcons name={icon} size={20} color={COLORS.primary} />
      </View>
      <Text style={styles.label}>{label}</Text>
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  button: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    paddingVertical: 14,
    paddingHorizontal: 16,
    backgroundColor: COLORS.white,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: COLORS.gray[200],
  },
  iconContainer: {
    width: 36,
    height: 36,
    borderRadius: 18,
    backgroundColor: 'rgba(19, 236, 91, 0.12)',
    alignItems: 'center',
    justifyContent: 'center',
  },
  label: {
    fontSize: 15,
    fontWeight: '600',
    color: COLORS.gray[900],
  },
});

export default ContactButton;
