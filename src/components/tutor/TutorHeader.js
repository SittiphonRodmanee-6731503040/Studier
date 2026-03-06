import React from 'react';
import { View, Text, StyleSheet, Image } from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { COLORS } from '../../utils/constants';
import StarRating from '../common/StarRating';

const TutorHeader = ({ tutor }) => {
  if (!tutor) {
    return null;
  }

  return (
    <View style={styles.container}>
      <View style={styles.avatarRow}>
        <Image source={{ uri: tutor.image }} style={styles.avatar} />
        <View style={styles.infoColumn}>
          <View style={styles.nameRow}>
            <Text style={styles.name}>{tutor.name}</Text>
            {tutor.verified && (
              <MaterialIcons name="verified" size={16} color={COLORS.primary} />
            )}
          </View>
          <Text style={styles.university}>{tutor.university}</Text>
          <Text style={styles.year}>{tutor.year}</Text>
        </View>
      </View>

      <Text style={styles.bio} numberOfLines={3}>
        {tutor.bio}
      </Text>

      <View style={styles.tagsRow}>
        {tutor.subjects.map((subject) => (
          <View key={subject} style={styles.tag}>
            <Text style={styles.tagText}>{subject}</Text>
          </View>
        ))}
      </View>

      <View style={styles.statsRow}>
        <View style={styles.statItem}>
          <Text style={styles.statValue}>{tutor.sessions}</Text>
          <Text style={styles.statLabel}>Sessions</Text>
        </View>
        <View style={styles.statDivider} />
        <View style={styles.statItem}>
          <View style={styles.ratingRow}>
            <StarRating rating={tutor.rating} size={14} />
            <Text style={styles.statValue}>{tutor.rating}</Text>
          </View>
          <Text style={styles.statLabel}>Rating</Text>
        </View>
        <View style={styles.statDivider} />
        <View style={styles.statItem}>
          <Text style={styles.statValue}>{tutor.reviews}</Text>
          <Text style={styles.statLabel}>Reviews</Text>
        </View>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    paddingHorizontal: 16,
    paddingTop: 16,
    paddingBottom: 8,
    backgroundColor: COLORS.white,
  },
  avatarRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 16,
    marginBottom: 12,
  },
  avatar: {
    width: 100,
    height: 100,
    borderRadius: 50,
    backgroundColor: COLORS.gray[200],
  },
  infoColumn: {
    flex: 1,
  },
  nameRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
    marginBottom: 4,
  },
  name: {
    fontSize: 20,
    fontWeight: '700',
    color: COLORS.gray[900],
  },
  university: {
    fontSize: 14,
    color: COLORS.gray[700],
  },
  year: {
    fontSize: 13,
    color: COLORS.gray[500],
    marginTop: 4,
  },
  bio: {
    fontSize: 14,
    color: COLORS.gray[700],
    lineHeight: 20,
    marginBottom: 12,
  },
  tagsRow: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 8,
    marginBottom: 16,
  },
  tag: {
    backgroundColor: COLORS.backgroundLight,
    borderRadius: 12,
    paddingHorizontal: 10,
    paddingVertical: 6,
  },
  tagText: {
    fontSize: 12,
    color: COLORS.gray[700],
    fontWeight: '600',
  },
  statsRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingVertical: 12,
    borderTopWidth: 1,
    borderTopColor: COLORS.gray[100],
  },
  statItem: {
    flex: 1,
    alignItems: 'center',
    gap: 4,
  },
  statDivider: {
    width: 1,
    height: 32,
    backgroundColor: COLORS.gray[100],
  },
  statValue: {
    fontSize: 16,
    fontWeight: '700',
    color: COLORS.gray[900],
  },
  statLabel: {
    fontSize: 12,
    color: COLORS.gray[500],
  },
  ratingRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
  },
});

export default TutorHeader;
