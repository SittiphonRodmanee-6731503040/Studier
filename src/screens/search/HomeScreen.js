import React, { useState } from 'react';
import { 
  View, 
  Text, 
  StyleSheet, 
  ScrollView, 
  TextInput, 
  TouchableOpacity,
  Image,
  StatusBar,
} from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { COLORS, SUBJECTS, MOCK_TUTORS } from '../../utils/constants';

const HomeScreen = ({ navigation }) => {
  const [activeSubject, setActiveSubject] = useState('For You');
  const [searchQuery, setSearchQuery] = useState('');

  const handleTutorPress = (tutor) => {
    navigation.navigate('TutorProfile', { tutorId: tutor.id, tutor });
  };

  const handleSubjectPress = (subject) => {
    setActiveSubject(subject);
    if (subject !== 'For You') {
      navigation.navigate('TutorList', { subject });
    }
  };

  return (
    <View style={styles.container}>
      <StatusBar barStyle="light-content" backgroundColor={COLORS.backgroundDark} />
      
      <ScrollView 
        style={styles.scrollView}
        showsVerticalScrollIndicator={false}
        stickyHeaderIndices={[0]}
      >
        {/* Header Section */}
        <View style={styles.headerContainer}>
          <View style={styles.header}>
            <View>
              <Text style={styles.greeting}>Good evening,</Text>
              <Text style={styles.userName}>Alex Johnson</Text>
            </View>
            <TouchableOpacity style={styles.notificationButton}>
              <MaterialIcons name="notifications-none" size={24} color={COLORS.white} />
              <View style={styles.notificationDot} />
            </TouchableOpacity>
          </View>

          {/* Search Bar */}
          <View style={styles.searchContainer}>
            <View style={styles.searchBar}>
              <MaterialIcons name="search" size={20} color={COLORS.gray[400]} style={styles.searchIcon} />
              <TextInput
                style={styles.searchInput}
                placeholder="Subject, tutor, or university..."
                placeholderTextColor={COLORS.gray[400]}
                value={searchQuery}
                onChangeText={setSearchQuery}
              />
              <TouchableOpacity style={styles.filterButton}>
                <MaterialIcons name="tune" size={18} color={COLORS.gray[300]} />
              </TouchableOpacity>
            </View>
          </View>
        </View>

        {/* Subject Tags */}
        <View style={styles.tagsSection}>
          <ScrollView 
            horizontal 
            showsHorizontalScrollIndicator={false}
            contentContainerStyle={styles.tagsContainer}
          >
            <TouchableOpacity 
              style={[styles.tag, activeSubject === 'For You' && styles.tagActive]}
              onPress={() => handleSubjectPress('For You')}
            >
              <MaterialIcons 
                name="auto-awesome" 
                size={16} 
                color={activeSubject === 'For You' ? COLORS.backgroundDark : COLORS.gray[300]} 
              />
              <Text style={[styles.tagText, activeSubject === 'For You' && styles.tagTextActive]}>
                For You
              </Text>
            </TouchableOpacity>

            {SUBJECTS.map((subject) => (
              <TouchableOpacity
                key={subject}
                style={[styles.tag, activeSubject === subject && styles.tagActive]}
                onPress={() => handleSubjectPress(subject)}
              >
                <Text style={[styles.tagText, activeSubject === subject && styles.tagTextActive]}>
                  #{subject}
                </Text>
              </TouchableOpacity>
            ))}
          </ScrollView>
        </View>

        {/* Featured Tutors Section */}
        <View style={styles.featuredSection}>
          <View style={styles.sectionHeader}>
            <Text style={styles.sectionTitle}>Featured Tutors</Text>
            <TouchableOpacity onPress={() => navigation.navigate('TutorList', { subject: 'All' })}>
              <Text style={styles.seeAllText}>See All</Text>
            </TouchableOpacity>
          </View>

          <View style={styles.tutorCardsContainer}>
            {MOCK_TUTORS.map((tutor) => (
              <TouchableOpacity
                key={tutor.id}
                style={styles.tutorCard}
                onPress={() => handleTutorPress(tutor)}
                activeOpacity={0.7}
              >
                <View style={styles.tutorCardLeft}>
                  <View style={styles.tutorImageContainer}>
                    <Image source={{ uri: tutor.image }} style={styles.tutorImage} />
                    {tutor.verified && (
                      <View style={styles.onlineBadge} />
                    )}
                  </View>
                </View>

                <View style={styles.tutorCardRight}>
                  <View style={styles.tutorHeader}>
                    <View style={styles.tutorNameContainer}>
                      <Text style={styles.tutorName}>{tutor.name}</Text>
                      {tutor.verified && (
                        <MaterialIcons name="verified" size={16} color={COLORS.primary} />
                      )}
                    </View>
                    <Text style={styles.tutorRate}>${tutor.hourlyRate}/hr</Text>
                  </View>

                  <Text style={styles.tutorUniversity}>{tutor.university}</Text>

                  <View style={styles.tutorTags}>
                    {tutor.subjects.slice(0, 2).map((subject, index) => (
                      <View key={index} style={styles.tutorTag}>
                        <Text style={styles.tutorTagText}>{subject}</Text>
                      </View>
                    ))}
                  </View>

                  <View style={styles.tutorStats}>
                    <View style={styles.tutorStat}>
                      <MaterialIcons name="star" size={14} color={COLORS.primary} />
                      <Text style={styles.tutorStatText}>{tutor.rating}</Text>
                      <Text style={styles.tutorStatSubtext}>({tutor.reviews} reviews)</Text>
                    </View>
                  </View>
                </View>
              </TouchableOpacity>
            ))}
          </View>
        </View>

        {/* Bottom Padding for Navigation */}
        <View style={styles.bottomPadding} />
      </ScrollView>

      {/* Bottom Navigation */}
      <View style={styles.bottomNav}>
        <TouchableOpacity style={styles.navItem} onPress={() => {}}>
          <MaterialIcons name="home" size={24} color={COLORS.primary} />
          <Text style={[styles.navText, styles.navTextActive]}>Home</Text>
        </TouchableOpacity>

        <TouchableOpacity style={styles.navItem} onPress={() => navigation.navigate('TutorList', { subject: 'All' })}>
          <MaterialIcons name="search" size={24} color={COLORS.gray[400]} />
          <Text style={styles.navText}>Explore</Text>
        </TouchableOpacity>

        <TouchableOpacity style={styles.navItemCenter}>
          <View style={styles.navCenterButton}>
            <MaterialIcons name="add" size={28} color={COLORS.backgroundDark} />
          </View>
        </TouchableOpacity>

        <TouchableOpacity style={styles.navItem}>
          <MaterialIcons name="chat-bubble-outline" size={24} color={COLORS.gray[400]} />
          <Text style={styles.navText}>Chat</Text>
        </TouchableOpacity>

        <TouchableOpacity style={styles.navItem} onPress={() => navigation.navigate('UserProfile')}>
          <MaterialIcons name="person-outline" size={24} color={COLORS.gray[400]} />
          <Text style={styles.navText}>Profile</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.backgroundDark,
  },
  scrollView: {
    flex: 1,
  },
  headerContainer: {
    backgroundColor: COLORS.backgroundDark + 'F2',
    paddingTop: 16,
    paddingBottom: 16,
    paddingHorizontal: 24,
    borderBottomWidth: 1,
    borderBottomColor: 'rgba(255, 255, 255, 0.05)',
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 24,
  },
  greeting: {
    fontSize: 14,
    color: COLORS.gray[400],
    fontWeight: '500',
    marginBottom: 4,
  },
  userName: {
    fontSize: 24,
    fontWeight: 'bold',
    color: COLORS.white,
    letterSpacing: -0.5,
  },
  notificationButton: {
    position: 'relative',
    padding: 8,
    borderRadius: 20,
  },
  notificationDot: {
    position: 'absolute',
    top: 8,
    right: 8,
    width: 8,
    height: 8,
    backgroundColor: COLORS.primary,
    borderRadius: 4,
    borderWidth: 2,
    borderColor: COLORS.backgroundDark,
  },
  searchContainer: {
    marginBottom: 0,
  },
  searchBar: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: COLORS.surfaceDark,
    borderRadius: 16,
    paddingHorizontal: 16,
    paddingVertical: 14,
    borderWidth: 1,
    borderColor: 'rgba(255, 255, 255, 0.1)',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 2,
  },
  searchIcon: {
    marginRight: 12,
  },
  searchInput: {
    flex: 1,
    fontSize: 15,
    color: COLORS.white,
  },
  filterButton: {
    padding: 6,
    backgroundColor: 'rgba(255, 255, 255, 0.1)',
    borderRadius: 8,
  },
  tagsSection: {
    marginTop: 0,
    marginBottom: 32,
  },
  tagsContainer: {
    paddingHorizontal: 24,
    paddingVertical: 8,
    gap: 12,
  },
  tag: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 20,
    paddingVertical: 10,
    backgroundColor: COLORS.surfaceDark,
    borderRadius: 20,
    borderWidth: 1,
    borderColor: 'rgba(255, 255, 255, 0.05)',
    marginRight: 12,
  },
  tagActive: {
    backgroundColor: COLORS.primary,
    borderColor: COLORS.primary,
    shadowColor: COLORS.primary,
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.2,
    shadowRadius: 8,
    elevation: 4,
  },
  tagText: {
    fontSize: 14,
    fontWeight: '500',
    color: COLORS.gray[300],
    marginLeft: 4,
  },
  tagTextActive: {
    color: COLORS.backgroundDark,
    fontWeight: '600',
  },
  featuredSection: {
    paddingHorizontal: 24,
  },
  sectionHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 20,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: COLORS.white,
  },
  seeAllText: {
    fontSize: 14,
    color: COLORS.primary,
    fontWeight: '600',
  },
  tutorCardsContainer: {
    gap: 16,
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
    shadowOpacity: 0.1,
    shadowRadius: 8,
    elevation: 2,
  },
  tutorCardLeft: {
    marginRight: 16,
  },
  tutorImageContainer: {
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
  tutorCardRight: {
    flex: 1,
  },
  tutorHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    marginBottom: 4,
  },
  tutorNameContainer: {
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
    fontSize: 16,
    fontWeight: 'bold',
    color: COLORS.primary,
  },
  tutorUniversity: {
    fontSize: 13,
    color: COLORS.gray[400],
    marginBottom: 8,
  },
  tutorTags: {
    flexDirection: 'row',
    gap: 8,
    marginBottom: 8,
  },
  tutorTag: {
    paddingHorizontal: 10,
    paddingVertical: 4,
    backgroundColor: 'rgba(19, 236, 91, 0.1)',
    borderRadius: 8,
  },
  tutorTagText: {
    fontSize: 11,
    color: COLORS.primary,
    fontWeight: '500',
  },
  tutorStats: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  tutorStat: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
  },
  tutorStatText: {
    fontSize: 13,
    fontWeight: '600',
    color: COLORS.white,
  },
  tutorStatSubtext: {
    fontSize: 12,
    color: COLORS.gray[400],
  },
  bottomPadding: {
    height: 100,
  },
  bottomNav: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    alignItems: 'center',
    backgroundColor: COLORS.surfaceDark,
    borderTopWidth: 1,
    borderTopColor: 'rgba(255, 255, 255, 0.05)',
    paddingVertical: 12,
    paddingHorizontal: 8,
  },
  navItem: {
    alignItems: 'center',
    justifyContent: 'center',
    flex: 1,
  },
  navItemCenter: {
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: -20,
  },
  navCenterButton: {
    width: 56,
    height: 56,
    backgroundColor: COLORS.primary,
    borderRadius: 28,
    alignItems: 'center',
    justifyContent: 'center',
    shadowColor: COLORS.primary,
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.3,
    shadowRadius: 8,
    elevation: 8,
  },
  navText: {
    fontSize: 11,
    color: COLORS.gray[400],
    marginTop: 4,
    fontWeight: '500',
  },
  navTextActive: {
    color: COLORS.primary,
    fontWeight: '600',
  },
});

export default HomeScreen;
