class SkillSpec {
  const SkillSpec(this.id, this.name, this.description, this.cost, this.mana);
  final String id, name, description;
  final int cost, mana;
}

const skills = [
  SkillSpec(
    'golpe',
    'Golpe poderoso',
    'Ignora coraza · daño base + 3 por rango',
    6,
    2,
  ),
  SkillSpec('cura', 'Curación', 'Recupera 6 de vida por rango', 8, 2),
  SkillSpec(
    'hielo',
    'Sello de hielo',
    'Retrasa el golpe enemigo 1 s por rango',
    10,
    2,
  ),
];

class HeroSpec {
  const HeroSpec(
    this.id,
    this.name,
    this.role,
    this.health,
    this.damage,
    this.description,
  );
  final String id, name, role, description;
  final int health, damage;
}

const heroes = [
  HeroSpec(
    'farol',
    'Luz',
    'Guardafaroles',
    20,
    1,
    'Equilibrio · bastón y pulsos de luz',
  ),
  HeroSpec(
    'bastion',
    'Bastión',
    'Centinela',
    28,
    1,
    'Resistencia · espada y escudo',
  ),
  HeroSpec(
    'ascua',
    'Ascua',
    'Invocadora',
    16,
    2,
    'Ofensiva · magia de fuego, menos vida',
  ),
];

class EnemySpec {
  const EnemySpec(
    this.id,
    this.name,
    this.health,
    this.damage,
    this.periodMs,
    this.description,
  );
  final String id, name, description;
  final int health, damage, periodMs;
}

const enemies = [
  EnemySpec(
    'mota',
    'Mota de hollín',
    8,
    4,
    3500,
    'Un golpe suave anunciado. Aprende a proteger tu luz.',
  ),
  EnemySpec(
    'acorazado',
    'Hollín acorazado',
    16,
    5,
    4500,
    'Su coraza reduce los pulsos. Guarda la llamarada para cuando se abra.',
  ),
  EnemySpec(
    'acechador',
    'Acechador de ceniza',
    20,
    8,
    3000,
    'Ataca más fuerte. Proteger a tiempo importa más que tocar rápido.',
  ),
  EnemySpec(
    'umbral',
    'Guardián del Umbral',
    48,
    8,
    4000,
    'Bajo media vida acelera su ataque. Una última luz para abrir el camino.',
  ),
];
const moduleNames = {
  'brasa': 'Brasa · +1 daño',
  'cristal': 'Cristal · llamarada ×4',
  'guarda': 'Guarda · protección total',
  'pabilo': 'Pabilo · carga en 3 ataques',
};
