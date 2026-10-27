export type UserRole = 'admin' | 'owner' | 'team_member' | 'viewer';

export interface Profile {
  id: string;
  fullName: string;
  role: UserRole;
  memberColor: string;
  canAccessMap: boolean;
  email: string;
  avatarUrl?: string;
  unreadNotificationsCount?: number;
}

export interface Category {
  id: string;
  name: string;
  isGeneralScope: boolean;
  sortOrder: number;
}

export interface ScopeOfWork {
  id: string;
  categoryId: string;
  title: string;
  description?: string;
  startDate: string;
  endDate: string;
  percentCompletion: number;
  assignedPersonId?: string;
}

export interface CommentAttachment {
  name: string;
  url: string;
  type: string;
}

export interface ScopeComment {
  id: string;
  scopeId: string;
  authorId: string;
  authorName: string;
  authorRole: UserRole;
  authorColor: string;
  message: string;
  photoUrl?: string;
  taggedPersonId?: string;
  isCallAttention: boolean;
  createdAt: string;
}

export interface NotificationItem {
  id: string;
  recipientId: string;
  senderId: string;
  senderName: string;
  scopeId: string;
  scopeTitle: string;
  commentId: string;
  message: string;
  isRead: boolean;
  createdAt: string;
}

export interface SiteSettings {
  companyName: string;
  companyLogoUrl: string;
  adminEmail: string;
  adminPhone: string;
  siteLatitude: number;
  siteLongitude: number;
  siteAddress: string;
}

export type ViewportMode = 'desktop' | 'tablet' | 'mobile';
export type Language = 'en' | 'fil' | 'hi';
export type ThemeMode = 'light' | 'dark';
