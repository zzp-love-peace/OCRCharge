export interface NavItem {
  icon: Resource;
  text: string;
  id: number;
}

export enum TabId {
  CHAT,
  RECEIPT,
  MINE
}

export const NavList: NavItem[] = [
  {
    icon: $r('app.media.ic_chart'),
    text: '报表',
    id: TabId.CHAT
  },
  {
    icon: $r('app.media.ic_receipt'),
    text: '账单',
    id: TabId.RECEIPT
  },
  {
    icon: $r('app.media.ic_mine'),
    text: '我的',
    id: TabId.MINE
  },
]