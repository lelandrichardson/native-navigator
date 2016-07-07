import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  TouchableOpacity,
  Text,
  View,
} from 'react-native';
import Navigator from './js/NavigatorModule';


class ScreenOne extends Component {
  render() {
    return (
      <Navigator.Scene
        title="ScreenOne"
        rightTitle="Next"
        menuItems={[

        ]}
        onAppear={(isFirstMount) => console.log("IM VISIBLE!")}
        onRightPress={() => console.log('onRightPress!')}
      >
        <View style={[styles.screen, styles.screen1]}>
          <Text>I am ScreenOne</Text>
          <TouchableOpacity onPress={() => Navigator.push('ScreenTwo')}>
            <Text>Push ScreenTwo</Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => Navigator.push('NativeExample')}>
            <Text>Push NativeExample</Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => Navigator.push('TabExample')}
          >
            <Text>Push TabExample</Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => Navigator.present('ModalOne')}>
            <Text>Present ModalOne</Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => Navigator.pop()}>
            <Text>Pop Me</Text>
          </TouchableOpacity>
        </View>
      </Navigator.Scene>
    );
  }
}

class ScreenTwo extends Component {
  render() {
    return (
      <Navigator.Scene title="ScreenTwo">
        <View style={[styles.screen, styles.screen2]}>
          <Text>I am ScreenTwo</Text>
          <TouchableOpacity onPress={() => Navigator.push('ScreenOne')}>
            <Text>Push ScreenOne</Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => Navigator.push('NativeExample', { initialTab: 'TabTwo'})}>
            <Text>Push NativeExample</Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => Navigator.push('TabExample')}>
            <Text>Push TabExample</Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => Navigator.pop()}>
            <Text>Pop Me</Text>
          </TouchableOpacity>
        </View>
      </Navigator.Scene>
    );
  }
}

class TabOne extends Component {
  render() {
    return (
      <Navigator.Scene title="TabOne">
        <View style={[styles.screen, styles.screen2]}>
          <Text>I am TabOne</Text>
          <TouchableOpacity onPress={() => Navigator.setTabIndex(1)}>
            <Text>Go to TabTwo</Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => Navigator.push('ScreenOne')}>
            <Text>Push ScreenOne</Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => Navigator.push('ScreenTwo')}>
            <Text>Push ScreenOne</Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => Navigator.push('NativeExample')}>
            <Text>Push NativeExample</Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => Navigator.pop()}>
            <Text>Pop Me</Text>
          </TouchableOpacity>
        </View>
      </Navigator.Scene>
    );
  }
}

class TabTwo extends Component {
  render() {
    return (
      <Navigator.Scene title="TabTwo">
        <View style={[styles.screen, styles.screen1]}>
          <Text>I am TabTwo</Text>
          <TouchableOpacity onPress={() => Navigator.setTabIndex(0)}>
            <Text>Go to TabOne</Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => Navigator.push('ScreenOne')}>
            <Text>Push ScreenOne</Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => Navigator.push('ScreenTwo')}>
            <Text>Push ScreenOne</Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => Navigator.push('NativeExample')}>
            <Text>Push NativeExample</Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => Navigator.pop()}>
            <Text>Pop Me</Text>
          </TouchableOpacity>
        </View>
      </Navigator.Scene>
    );
  }
}

class ModalOne extends Component {
  render() {
    return (
      <Navigator.Scene title="ModalOne">
        <View style={[styles.screen, { backgroundColor: 'orange' }]}>
          <Text>I am ModalOne</Text>
          <TouchableOpacity onPress={() => Navigator.dismiss()}>
            <Text>Dismiss!</Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => Navigator.push('ScreenOne')}>
            <Text>Push ScreenOne</Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => Navigator.push('ScreenTwo')}>
            <Text>Push ScreenOne</Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => Navigator.push('NativeExample')}>
            <Text>Push NativeExample</Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => Navigator.pop()}>
            <Text>Pop Me</Text>
          </TouchableOpacity>
        </View>
      </Navigator.Scene>
    );
  }
}

const styles = StyleSheet.create({
  screen: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  screen1: {
    backgroundColor: 'red',
  },
  screen2: {
    backgroundColor: 'green',
  },
});


//Navigator.createTabScene([
//  { component: 'ScreenOne' },
//]);

//registerSceneWithReduxStore(store, 'ScreenName', Screen);


//Navigator.registerScene('ScreenOneOrLogin', function Component(props) {
//  return props.hasTrips ? <ScreenOne /> : <ScreenTwo />
//});

Navigator.registerScene('ScreenOne', ScreenOne);
Navigator.registerScene('ScreenTwo', ScreenTwo);
Navigator.registerScene('TabOne', TabOne);
Navigator.registerScene('TabTwo', TabTwo);
Navigator.registerScene('ModalOne', ModalOne);
