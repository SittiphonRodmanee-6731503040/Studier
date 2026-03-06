import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { COLORS } from '../../utils/constants';
import StarRating from '../common/StarRating';

const ReviewItem = ({ review }) => {
  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <View>
          <Text style={styles.userName}>{review.userName}</Text>
          <Text style={styles.metaText}>{review.courseContext}</Text>
        </View>
        <View style={styles.ratingColumn}>
          <StarRating rating={review.rating} size={14} />
          <Text style={styles.dateText}>{review.date}</Text>
        </View>
      </View>
      <Text style={styles.comment}>{review.comment}</Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    paddingVertical: 12,
    borderBottomWidth: 1,
    borderBottomColor: COLORS.gray[100],
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 8,
  },
  userName: {
    fontSize: 14,
    fontWeight: '700',
    color: COLORS.gray[900],
  },
  metaText: {
    fontSize: 12,
    color: COLORS.gray[500],
    marginTop: 2,
  },
  ratingColumn: {
    alignItems: 'flex-end',
    gap: 4,
  },
  dateText: {
    fontSize: 11,
    color: COLORS.gray[400],
  },
  comment: {
    fontSize: 13,
    color: COLORS.gray[700],
    lineHeight: 18,
  },
});

export default ReviewItem;
