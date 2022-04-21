class Projector:
  def on(self):
    raise NotImplementedError

  def off(self):
    raise NotImplementedError

  def is_on(self):
    raise NotImplementedError

  def is_off(self):
    return not self.is_on()