import './header.styl';
import Component from '../components/component.react';
import React from 'react';
import {Link} from 'react-router';

export default class Header extends Component {

  static propTypes = {
    msg: React.PropTypes.object.isRequired,
    viewer: React.PropTypes.object
  }

  render() {
    const {msg: {app: {header: msg}}, viewer} = this.props;

    return (
      <header className="app-header">
        <h1>
          <Link to="home">{msg.home}</Link>
        </h1>
        <ul>
          <li><Link to="latest">{msg.latest}</Link></li>
          <li><Link to="my-songs">{msg.mySongs}</Link></li>
          <li><Link to="add-song">{msg.addSong}</Link></li>
          {viewer
            ? <li><Link to="me">{msg.me}</Link></li>
            : <li><Link to="login">{msg.login}</Link></li>
          }
        </ul>
      </header>
    );
  }

}
