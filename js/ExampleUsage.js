import {
  Actions,
  Router,
  Scene,
  Navigate,
  registerRoutes,
} from 'native-navigator';


@Scene('ScreenOne')
class ScreenOne extends Component {
  // NativeNavigator-specific Attributes
  static uniqueName = "ScreenOne";

  // DLS-specific Attributes
  static sceneType = "Specialty";
  static color = 'white';
  static trailerButtons = ['calendar', 'filter'];
  static trailerLink = '';


  static navigation = {
    title: props => props.name,
  };
  static buttonType = "close";

  onPress() {
    Navigate.push('ScreenOne', { foo: 'bar' });
  }

  render() {
    return (
      <Scene
        backButtonType
      >

      </Scene>
    );
    // ...
  }
}




registerRoutes(
  <Router>
    <Scene component={ScreenOne} />
  </Router>
);
