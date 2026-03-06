import React, { useState } from 'react';
import { 
  View, 
  Text, 
  StyleSheet, 
  FlatList, 
  TouchableOpacity, 
  Image,
  StatusBar,
  ScrollView,
} from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { COLORS, MOCK_TUTORS } from '../../utils/constants';

const TutorListScreen = ({ navigation, route }) => {
  const { subject } = route.params;
  const [activeFilters, setActiveFilters] = useState([]);

  const handleTutorPress = (tutor) => {
    navigation.navigate('TutorProfile', { tutorId: tutor.id, tutor });
  };

  const toggleFilter = (filter) => {
    if (activeFilters.includes(filter)) {
      setActiveFilters(activeFilters.filter(f => f !== filter));
    } else {
      setActiveFilters([...activeFilters, filter]);
    }
  };

  const renderTutor = ({ item }) => (
    <TouchableOpacity
      style={styles.tutorCard}
      onPress={() => handleTutorPress(item)}
      activeOpacity={0.7}
    >
      <View style={styles.tutorImageContainer}>
        <Image source={{ uri: item.image }} style={styles.tutorImage} />
        {item.verified && (
          <View style={styles.onlineBadge} />
        )}
      </View>

      <View style={styles.tutorInfo}>
        <View style={styles.tutorHeader}>
          <View style={styles.tutorNameRow}>
            <Text style={styles.tutorName}>{item.name}</Text>
            {item.verified && (
              <MaterialIcons name="verified" size={16} color={COLORS.primary} />
            )}
          </View>
          <Text style={styles.tutorRate}>${item.hourlyRate}/hr</Text>
        </View>

        <Text style={styles.tutorUniversity} numberOfLines={1}>{item.university}</Text>

        <Text style={styles.tutorDescription} numberOfLines={2}>
          {item.about}
        </Text>

        <View style={styles.tutorTags}>
          {item.tags ? item.tags.slice(0, 3).map((tag, index) => (
            <View key={index} style={styles.tagChip}>
              <View style={styles.tagDot} />
              <Text style={styles.tagText}>{tag}</Text>
            </View>
          )) : item.subjects.slice(0, 3).map((subject, index) => (
            <View key={index} style={styles.tagChip}>
              <View style={styles.tagDot} />
              <Text style={styles.tagText}>{subject}</Text>
            </View>
          ))}
        </View>

        <View style={styles.tutorStats}>
          <View style={styles.stat}>
            <MaterialIcons name="star" size={14} color={COLORS.primary} />
            <Text style={styles.statText}>{item.rating}</Text>
          </View>
          <View style={styles.stat}>
            <MaterialIcons name="rate-review" size={14} color={COLORS.gray[400]} />
            <Text style={styles.statText}>{item.reviews} reviews</Text>
          </View>
        </View>
      </View>
    </TouchableOpacity>
  );

  return (
    <View style={styles.container}>
      <StatusBar barStyle="light-content" backgroundColor={COLORS.backgroundDark} />

      {/* Header */}
      <View style={styles.header}>
        <View style={styles.headerTop}>
          <TouchableOpacity 
            style={styles.backButton}
            onPress={() => navigation.goBack()}
          >
            <MaterialIcons name="chevron-left" size={28} color={COLORS.white} />
          </TouchableOpacity>

          <View style={styles.headerCenter}>
            <Text style={styles.headerTitle}>#{subject}</Text>
            <Text style={styles.headerSubtitle}>{MOCK_TUTORS.length} tutors available</Text>
          </View>

          <TouchableOpacity style={styles.searchButton}>
            <MaterialIcons name="search" size={24} color={COLORS.white} />
          </TouchableOpacity>
        </View>

        {/* Filter Row */}
        <ScrollView 
          horizontal 
          showsHorizontalScrollIndicator={false}
          contentContainerStyle={styles.filtersContainer}
        >
          <TouchableOpacity 
            style={styles.filterButtonPrimary}
            onPress={() => {}}
          >
            <MaterialIcons name="tune" size={18} color={COLORS.backgroundDark} />
            <Text style={styles.filterTextPrimary}>Filter</Text>
          </TouchableOpacity>

          <TouchableOpacity 
            style={[
              styles.filterButton,
              activeFilters.includes('price') && styles.filterButtonActive
            ]}
            onPress={() => toggleFilter('price')}
          >
            <Text style={[
              styles.filterText,
              activeFilters.includes('price') && styles.filterTextActive
            ]}>
              Under $20/hr
            </Text>
          </TouchableOpacity>

          <TouchableOpacity 
            style={[
              styles.filterButton,
              activeFilters.includes('rating') && styles.filterButtonActive
            ]}
            onPress={() => toggleFilter('rating')}
          >
            <Text style={[
              styles.filterText,
              activeFilters.includes('rating') && styles.filterTextActive
            ]}>
              5 Stars
            </Text>
          </TouchableOpacity>

          <TouchableOpacity 
            style={[
              styles.filterButton,
              activeFilters.includes('available') && styles.filterButtonActive
            ]}
            onPress={() => toggleFilter('available')}
          >
            <Text style={[
              styles.filterText,
              activeFilters.includes('available') && styles.filterTextActive
            ]}>
              Available Now
            </Text>
          </TouchableOpacity>
        </ScrollView>
      </View>

      {/* Tutor List */}
      <FlatList
        data={MOCK_TUTORS}
        renderItem={renderTutor}
        keyExtractor={(item) => item.id}
        contentContainerStyle={styles.listContent}
        showsVerticalScrollIndicator={false}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.backgroundDark,
  },
  header: {
    paddingTop: 16,
    paddingBottom: 16,
    paddingHorizontal: 20,
    backgroundColor: COLORS.backgroundDark,
    borderBottomWidth: 1,
    borderBottomColor: 'rgba(255, 255, 255, 0.05)',
  },
  headerTop: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 16,
  },
  backButton: {
    padding: 8,
    marginLeft: -8,
    borderRadius: 20,
  },
  headerCenter: {
    flex: 1,
    alignItems: 'center',
  },
  headerTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: COLORS.white,
    letterSpacing: -0.5,
  },
  headerSubtitle: {
    fontSize: 12,
    color: COLORS.primary,
    marginTop: 2,
    fontWeight: '500',
  },
  searchButton: {
    padding: 8,
    marginRight: -8,
    borderRadius: 20,
  },
  filtersContainer: {
    paddingVertical: 4,
    gap: 12,
  },
  filterButtonPrimary: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    backgroundColor: COLORS.primary,
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderRadius: 20,
    shadowColor: COLORS.primary,
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.2,
    shadowRadius: 8,
    elevation: 4,
  },
  filterTextPrimary: {
    fontSize: 14,
    fontWeight: '600',
    color: COLORS.backgroundDark,
  },
  filterButton: {
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderRadius: 20,
    backgroundColor: 'rgba(255, 255, 255, 0.05)',
    borderWidth: 1,
    borderColor: 'rgba(255, 255, 255, 0.1)',
  },
  filterButtonActive: {
    backgroundColor: COLORS.primary,
    borderColor: COLORS.primary,
  },
  filterText: {
    fontSize: 14,
    fontWeight: '500',
    color: COLORS.gray[300],
  },
  filterTextActive: {
    color: COLORS.backgroundDark,
    fontWeight: '600',
  },
  listContent: {
    padding: 16,
    gap: 16,
    paddingBottom: 32,
  },
  tutorCard: {
    flexDirection: 'row',
    backgroundColor: COLORS.surfaceDark,
    borderRadius: 16,
    padding: 16,
    borderWidth: 1,
    borderColor: 'rgba(255, 255, 255, 0.05)',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.2,
    shadowRadius: 8,
    elevation: 3,
  },
  tutorImageContainer: {
    marginRight: 16,
    position: 'relative',
  },
  tutorImage: {
    width: 80,
    height: 80,
    borderRadius: 12,
    backgroundColor: COLORS.gray[700],
  },
  onlineBadge: {
    position: 'absolute',
    bottom: 4,
    right: 4,
    width: 14,
    height: 14,
    backgroundColor: COLORS.primary,
    borderRadius: 7,
    borderWidth: 2,
    borderColor: COLORS.surfaceDark,
  },
  tutorInfo: {
    flex: 1,
  },
  tutorHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    marginBottom: 4,
  },
  tutorNameRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    flex: 1,
  },
  tutorName: {
    fontSize: 16,
    fontWeight: 'bold',
    color: COLORS.white,
  },
  tutorRate: {
    fontSize: 15,
    fontWeight: 'bold',
    color: COLORS.primary,
  },
  tutorUniversity: {
    fontSize: 13,
    color: COLORS.gray[400],
    marginBottom: 6,
  },
  tutorDescription: {
    fontSize: 13,
    color: COLORS.gray[300],
    lineHeight: 18,
    marginBottom: 8,
  },
  tutorTags: {
    flexDirection: 'row',
    gap: 8,
    marginBottom: 8,
    flexWrap: 'wrap',
  },
  tagChip: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    paddingHorizontal: 8,
    paddingVertical: 3,
    backgroundColor: 'rgba(19, 236, 91, 0.1)',
    borderRadius: 8,
  },
  tagDot: {
    width: 4,
    height: 4,
    backgroundColor: COLORS.primary,
    borderRadius: 2,
  },
  tagText: {
    fontSize: 11,
    color: COLORS.primary,
    fontWeight: '500',
  },
  tutorStats: {
    flexDirection: 'row',
    gap: 16,
  },
  stat: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
  },
  statText: {
    fontSize: 12,
    color: COLORS.gray[300],
    fontWeight: '500',
  },
});

export default TutorListScreen;
44