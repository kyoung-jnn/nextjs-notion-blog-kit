import { ComponentProps } from 'react';

import Icon from './Icon';

interface Props extends ComponentProps<'button'> {
  name: ComponentProps<typeof Icon>['name'];
}

function IconButton({ name, ...attributes }: Props) {
  return (
    <button
      className="flex w-fit h-fit p-[3px] rounded-[3px] cursor-pointer transition-all duration-400 hover:bg-gray-500"
      {...attributes}
    >
      <Icon name={name} />
    </button>
  );
}

export default IconButton;
