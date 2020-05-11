import UserAdmin from '/imports/ui/UserAdmin'
import RuleEditor from '/imports/ui/RuleEditor/RuleEditor'
import Playground from '/imports/ui/Playground/Playground'
import DataAdmin from '/imports/ui/DataAdmin/DataAdmin'
import CodeListenEditor from '/imports/ui/CodeListenEditor/CodeListenEditor'
import Ergebnislisten from '/imports/ui/Ergebnislisten/Ergebnislisten'
import LandingPage from '/imports/ui/LandingPage'
import Help from '/imports/ui/Help/Help'

import MenuLogo from '/imports/ui/parts/MenuLogo'
# import AutoTableTest from '/imports/ui/AutoTableTest'
# import MeteorMethodButtonTest from '/imports/ui/MeteorMethodButtonTest'

export default appRouterItems = [
  customMenuItemContent: MenuLogo
  label: 'EOPTI'
  path: '/home'
  component: LandingPage
  icon:
    name: 'home'
,
  label: 'Benutzer'
  path: '/benutzer-verwaltung'
  component: UserAdmin
  role: 'user_view'
  icon:
    name: 'users'
,
  label: 'Regeleditor'
  path: '/regeleditor'
  component: RuleEditor
  role: 'rule_view'
  icon:
    name: 'edit'
,
  label: 'Listeneditor'
  path: '/listeneditor'
  component: CodeListenEditor
  role: 'rule_view'
  icon:
    name: 'list'
# ,
#   label: 'Spielplatz'
#   path: '/spielplatz'
#   component: Playground
#   role: 'playground_view'
#   icon:
#     name: 'child'
,
  path: '/spielplatz/:fallId'
  role: 'playground_view'
  component: Playground
  showInMenu: false
,
  label: 'Daten verwalten'
  path: '/daten-verwalten'
  component: DataAdmin
  role: 'data_view'
  icon:
    name: 'save'
,
  label: 'Ergebnislisten'
  path: '/ergebnislisten'
  component: Ergebnislisten
  role: 'ergebnisliste_page_view'
  icon:
    name: 'clipboard check'
,
  label: 'Hilfe'
  path: '/help'
  component: Help
  role: 'user'
  icon:
    name: 'help'
  openInNewWindow: true
  windowSize: "width=1024, height=768" #TODO REDESIGN Anfangsgröße Hilfefenster
# ,
#   label: 'AutoTable Test'
#   path: '/autotable-test'
#   component: AutoTableTest
#   role: 'dev'
#   hideIfDisabled: true
# ,
#   label: 'Button Test'
#   path: '/button-test'
#   component: MeteorMethodButtonTest
#   role: 'dev'
#   hideIfDisabled: true
]
