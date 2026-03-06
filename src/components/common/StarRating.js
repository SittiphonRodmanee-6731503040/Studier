import React from 'react';
import { View, StyleSheet } from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { COLORS } from '../../utils/constants';

const StarRating = ({ rating = 0, maxStars = 5, size = 16, color = COLORS.primary }) => {
  const stars = [];
  const fullStars = Math.floor(rating);
  const hasHalf = rating - fullStars >= 0.5;

  for (let i = 0; i < maxStars; i += 1) {
    let iconName = 'star-border';
    if (i < fullStars) {
      iconName = 'star';
    } else if (i === fullStars && hasHalf) {
      iconName = 'star-half';
    }
    stars.push(
      <MaterialIcons key={`star-${i}`} name={iconName} size={size} color={color} />
    );
  }

  return <View style={styles.container}>{stars}</View>;
};

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
  },
});

export default StarRating;
