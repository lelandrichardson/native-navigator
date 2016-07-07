import React, { PropTypes } from 'react';
import {
  AppRegistry,
  StyleSheet,
  NativeModules,
  View,
  DeviceEventEmitter,
} from 'react-native';
const { RNNNavigatorModule,  } = NativeModules;

if (!RNNNavigatorModule) {
  throw new Error("RNNNavigatorModule Not Found!");
}

class Scene extends React.Component {
  constructor(props, context) {
    super(props, context);
    this.subscriptions = {};
    this.handleProps(props, {}, context.viewControllerId);
  }

  componentWillReceiveProps(nextProps, nextContext) {
    this.handleProps(nextProps, this.props, nextContext.viewControllerId);
  }

  componentWillUnmount() {
    console.log("componentWillUnmount");
    Object.keys(this.subscriptions)
      .forEach(key => DeviceEventEmitter.removeSubscription(this.subscriptions[key]));
  }

  handleProps(next, prev, id) {
    if (next.title !== prev.title) {
      RNNNavigatorModule.setTitle(id, next.title);
    }
    if (next.rightTitle !== prev.rightTitle) {
      RNNNavigatorModule.setRightTitle(id, next.rightTitle);
    }
    this.setCallbackIfNeeded('onRightPress', next, prev, id);
    this.setCallbackIfNeeded('onAppear', next, prev, id);
    this.setCallbackIfNeeded('onDisappear', next, prev, id);
  }

  setCallbackIfNeeded(event, next, prev, id) {
    if (next[event] !== prev[event]) {
      this.setCallback(event, id, next[event]);
    }
  }

  setCallback(event, id, cb) {
    const key = `NNNavigatorScene.${event}.${id}`;
    if (this.subscriptions[key]) {
      DeviceEventEmitter.removeSubscription(this.subscriptions[key]);
    }
    console.log("subscribing to: ", key);
    this.subscriptions[key] = DeviceEventEmitter.addListener(key, cb);
  }

  render() {
    if (this.props.children) {
      return (
        <View style={style.scene}>
          {this.props.children}
        </View>
      );
    } else {
      return null;
    }
  }
}

Scene.propTypes = {
  children: PropTypes.node,

  // Scene attributes
  title: PropTypes.string,
  rightTitle: PropTypes.string,
  onRightPress: PropTypes.func,
  tabIcon: PropTypes.object,
  tabTitle: PropTypes.string,
  statusBarStyle: PropTypes.string,
  statusBarHidden: PropTypes.bool,
  onAppear: PropTypes.func,
  onDisappear: PropTypes.func,
  onDismiss: PropTypes.func,

  // Airbnb-specific attributes
  color: PropTypes.string,
  leftIcon: PropTypes.string,
  type: PropTypes.string, // "specialty", "static", etc.
  trailerLink: PropTypes.string,
  onTrailerLinkPress: PropTypes.func,
  onLeftPress: PropTypes.func,
};

Scene.contextTypes = {
  viewControllerId: PropTypes.string,
};

const style = StyleSheet.create({
  scene: {
    position: 'absolute',
    top: 0,
    left: 0,
    bottom: 0,
    right: 0,
  },
});

const NavigatorModule = {

  Scene,

  registerScene(SceneName, SceneComponent) {

    class WrappedScene extends React.Component {
      getChildContext() {
        return {
          viewControllerId: this.props.viewControllerId,
        };
      }
      render() {
        return <SceneComponent {...this.props} />
      }
    }

    WrappedScene.childContextTypes = {
      viewControllerId: PropTypes.string
    };

    AppRegistry.registerComponent(SceneName, () => WrappedScene);

    // TODO(lmr): do we want to return SceneComponent or WrappedScene???
    return SceneComponent;
  },

  push(screenName, props = null, animated = true) {
    if (typeof screenName === 'function') {
      // TODO(lmr): handle the ability for users to pass in a component instead of a string name.
      // we could put the identifier statically on the constructor, and look for it here and
      // throw if it's not present...
    }
    if (AppRegistry.getAppKeys().indexOf(screenName) !== -1) {
      RNNNavigatorModule.push(screenName, props, animated);
    } else {
      RNNNavigatorModule.pushNative(screenName, props, animated);
    }
  },
  pop(payload = null, animated = true) {
    RNNNavigatorModule.pop(payload, animated);
  },
  replace(screenName, props = null, animated = true) {
    // TODO(lmr): needed?
  },
  setTabIndex(index, animated = true) {
    RNNNavigatorModule.setTabIndex(index, animated);
  },
  present(screenName, props = null, animated = true) {
    if (AppRegistry.getAppKeys().indexOf(screenName) !== -1) {
      RNNNavigatorModule.present(screenName, props, animated);
    } else {
      RNNNavigatorModule.presentNative(screenName, props, animated);
    }
  },
  dismiss(payload = null, animated = true) {
    RNNNavigatorModule.dismiss(payload, animated);
  },
};

module.exports = NavigatorModule;
