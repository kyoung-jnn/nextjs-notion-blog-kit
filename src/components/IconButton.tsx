import { ComponentProps } from 'react';

import Icon from './Icon';

import * as styles from './IconButton.css';

interface Props extends ComponentProps<'button'> {
  name: ComponentProps<typeof Icon>['name'];
}

function IconButton({ name, ...attributes }: Props) {
  return (
    <button className={styles.wrapper} {...attributes}>
      <Icon name={name} />
    </button>
  );
}

export default IconButton;
