import React, { useEffect, useMemo, useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  ActivityIndicator,
  TouchableOpacity,
  FlatList,
  Linking,
} from 'react-native';
import TutorHeader from '@/components/tutor/TutorHeader';
import ReviewItem from '@/components/tutor/ReviewItem';
import ContactButton from '@/components/common/ContactButton';
import StarRating from '@/components/common/StarRating';
import { COLORS, MOCK_REVIEWS, MOCK_TUTORS } from '../../utils/constants';

const TutorProfileScreen = ({ navigation, route }) => {
  const { tutorId } = route.params || {};
  const [loading, setLoading] = useState(true);

  const tutor = useMemo(
    () => MOCK_TUTORS.find((item) => item.id === tutorId),
    [tutorId]
  );

  const reviews = useMemo(
    () => MOCK_REVIEWS.filter((review) => review.tutorId === tutorId),
    [tutorId]
  );

  useEffect(() => {
    const timer = setTimeout(() => setLoading(false), 350);
    return () => clearTimeout(timer);
  }, []);

  const handleOpenLine = () => {
    if (!tutor?.lineId) {
      return;
    }
    Linking.openURL(`https://line.me/ti/p/~${tutor.lineId}`);
  };

  const handleOpenInstagram = () => {
    if (!tutor?.instagramHandle) {
      return;
    }
    Linking.openURL(`https://instagram.com/${tutor.instagramHandle}`);
  };

  if (loading) {
    return (
      <View style={styles.centered}>
        <ActivityIndicator size="large" color={COLORS.primary} />
        <Text style={styles.loadingText}>Loading tutor profile...</Text>
      </View>
    );
  }

  if (!tutor) {
    return (
      <View style={styles.centered}>
        <Text style={styles.errorTitle}>Tutor not found</Text>
        <Text style={styles.errorSubtitle}>Please go back and try again.</Text>
        <TouchableOpacity style={styles.errorButton} onPress={() => navigation.goBack()}>
          <Text style={styles.errorButtonText}>Go Back</Text>
        </TouchableOpacity>
      </View>
    );
  }

  const visibleReviews = reviews.slice(0, 5);

  return (
    <ScrollView style={styles.container} showsVerticalScrollIndicator={false}>
      <TutorHeader tutor={tutor} />

      <View style={styles.divider} />

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Contact Tutor</Text>
        <View style={styles.contactList}>
          <ContactButton
            icon="chat"
            label="Contact via Line"
            onPress={handleOpenLine}
          />
          <ContactButton
            icon="camera-alt"
            label="Contact via Instagram"
            onPress={handleOpenInstagram}
          />
        </View>
      </View>

      <View style={styles.divider} />

      <View style={styles.section}>
        <View style={styles.sectionHeader}>
          <View>
            <Text style={styles.sectionTitle}>Reviews ({reviews.length})</Text>
            <View style={styles.ratingRow}>
              <StarRating rating={tutor.rating} size={16} />
              <Text style={styles.ratingText}>{tutor.rating} average</Text>
            </View>
          </View>
        </View>

        <FlatList
          data={visibleReviews}
          keyExtractor={(item) => item.id}
          renderItem={({ item }) => <ReviewItem review={item} />}
          scrollEnabled={false}
          contentContainerStyle={styles.reviewList}
        />

        {reviews.length > 5 && (
          <TouchableOpacity style={styles.seeAllButton}>
            <Text style={styles.seeAllText}>See all reviews</Text>
          </TouchableOpacity>
        )}
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.white,
  },
  section: {
    paddingHorizontal: 16,
    paddingVertical: 16,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '700',
    color: COLORS.gray[900],
    marginBottom: 12,
  },
  divider: {
    height: 1,
    backgroundColor: COLORS.gray[200],
    marginHorizontal: 16,
  },
  contactList: {
    gap: 12,
  },
  sectionHeader: {
    marginBottom: 8,
  },
  ratingRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  ratingText: {
    fontSize: 13,
    color: COLORS.gray[600],
    fontWeight: '600',
  },
  reviewList: {
    paddingBottom: 8,
  },
  seeAllButton: {
    alignSelf: 'flex-start',
    marginTop: 8,
    paddingVertical: 6,
  },
  seeAllText: {
    fontSize: 14,
    fontWeight: '600',
    color: COLORS.primary,
  },
  centered: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: COLORS.white,
    padding: 24,
  },
  loadingText: {
    marginTop: 12,
    fontSize: 14,
    color: COLORS.gray[600],
  },
  errorTitle: {
    fontSize: 18,
    fontWeight: '700',
    color: COLORS.gray[900],
    marginBottom: 6,
  },
  errorSubtitle: {
    fontSize: 14,
    color: COLORS.gray[600],
    marginBottom: 16,
  },
  errorButton: {
    backgroundColor: COLORS.primary,
    paddingHorizontal: 16,
    paddingVertical: 10,
    borderRadius: 10,
  },
  errorButtonText: {
    color: COLORS.backgroundDark,
    fontWeight: '700',
  },
});

export default TutorProfileScreen;
