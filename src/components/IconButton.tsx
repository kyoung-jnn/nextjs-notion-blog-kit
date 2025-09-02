import { ComponentProps } from 'react';

import Icon from './Icon';

interface Props extends ComponentProps<'button'> {
  name: ComponentProps<typeof Icon>['name'];
}

function IconButton({ name, ...attributes }: Props) {
  return (
    <button
      className="flex h-fit w-fit cursor-pointer rounded-[3px] p-[3px] transition-all duration-400 hover:bg-gray-400"
      {...attributes}
    >
      <Icon name={name} />
    </button>
  );
}

export default IconButton;
